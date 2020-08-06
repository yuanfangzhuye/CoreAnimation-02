//
//  ViewController.m
//  CoreAnimation-02
//
//  Created by tlab on 2020/8/6.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CAEmitterLayer *colorBallLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    label.textColor = [UIColor whiteColor];
    label.text = @"轻点或拖动来改变发射源位置";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [self setupEmitter];
}

- (void)setupEmitter
{
    self.colorBallLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:self.colorBallLayer];
    
    //发射源的尺寸大小
    self.colorBallLayer.emitterSize = self.view.frame.size;
    //发射源的形状
    self.colorBallLayer.emitterShape = kCAEmitterLayerPoint;
    //发射模式
    self.colorBallLayer.emitterMode = kCAEmitterLayerPoints;
    //粒子发射形状的中心点
    self.colorBallLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width, 0);
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    //粒子名称
    cell.name = @"colorBallCell";
    //粒子产生率,默认为0
    cell.birthRate = 20.0f;
    //粒子生命周期
    cell.lifetime = 10.0f;
    //粒子速度,默认为0
    cell.velocity = 40.0f;
    //粒子速度平均量
    cell.velocityRange = 100.0f;
    //x,y,z方向上的加速度分量,三者默认都是0
    cell.yAcceleration = 15.0f;
    
    //指定纬度,纬度角代表了在x-z轴平面坐标系中与x轴之间的夹角，默认0
    cell.emissionLongitude = M_PI; // 向左
    //发射角度范围,默认0，以锥形分布开的发射角度。角度用弧度制。粒子均匀分布在这个锥形范围内
    cell.emissionRange = M_PI_4; // 围绕X轴向左90度
    
    // 缩放比例, 默认是1
    cell.scale = 0.2f;
    // 缩放比例范围,默认是0
    cell.scaleRange = 0.1f;
    // 在生命周期内的缩放速度,默认是0
    cell.scaleSpeed = 0.02;
    
    // 粒子的内容，为CGImageRef的对象
    cell.contents = (id)[[UIImage imageNamed:@"circle_white"] CGImage];
    
    //颜色
    cell.color = [[UIColor colorWithRed:0.5 green:0.0f blue:0.5f alpha:1.0f] CGColor];
    
    // 粒子颜色red,green,blue,alpha能改变的范围,默认0
    cell.redRange = 1.0f;
    cell.greenRange = 1.0f;
    cell.alphaRange = 0.8f;
    
    // 粒子颜色red,green,blue,alpha在生命周期内的改变速度,默认都是0
    cell.blueSpeed = 1.0f;
    cell.alphaSpeed = -0.1f;
    
    self.colorBallLayer.emitterCells = @[cell];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPosition:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPosition:point];
}

/**
* 获取手指所在点
*/
- (CGPoint)locationFromTouchEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    return [touch locationInView:self.view];
}

- (void)setBallInPosition:(CGPoint)position
{
    //创建基础动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.colorBallCell.scale"];
    basicAnimation.fromValue = @0.2f;
    basicAnimation.toValue = @0.5f;
    basicAnimation.duration = 1.0f;
    
    //线性起搏，使动画在其持续时间内均匀地发生
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // 用事务包装隐式动画
    [CATransaction begin];
    //设置是否禁止由于该事务组内的属性更改而触发的操作
    [CATransaction setDisableActions:YES];
    //为colorBallLayer 添加动画
    [self.colorBallLayer addAnimation:basicAnimation forKey:nil];
    //为colorBallLayer 指定位置添加动画效果
    [self.colorBallLayer setValue:[NSValue valueWithCGPoint:position] forKeyPath:@"emitterPosition"];
    //提交动画
    [CATransaction commit];
}


@end
