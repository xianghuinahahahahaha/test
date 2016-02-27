//
//  ViewController.m
//  OurAliPayDemo
//
//  Created by qianfeng007 on 16/2/27.
//  Copyright © 2016年 项会娜. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "MyPayHeader.h"
#import "DataSigner.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *payButton =[UIButton buttonWithType:UIButtonTypeSystem];
    payButton.frame = CGRectMake(10, 30, 100, 40);
    [payButton setTitle:@"购买" forState:0];
    payButton.backgroundColor = [UIColor redColor];
    [payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

-(void)pay{
    
    Order *order  = [[Order alloc]init];
    order.partner = PartnerID;
    order.seller  =  SellerID;
    //交易号
    order.tradeNO = @"1511";
    //产品名称
    order.productName = @"iphone6";
    //产品秒数
    order.productDescription = @"iphone 6降价处理";
    //商品价格
    order.amount = @"0.01";
    //当交易成功后，或给该url发送post通知
    order.notifyURL = @"http://www.baidu.com";
    //交易服务器，固定
    order.service   = @"mobile.securitypay.pay";
    //交易类型，商品交易
    order.paymentType= @"1";
    
    order.inputCharset = @"utf-8";
    //超时时间，m分，h时 d天，超时交易自动关闭
    order.itBPay = @"30m";
    
    //要在URL Scheme中设置同样的字符串
    NSString *appScheme = @"alipayDemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //使用私钥进行数据签名
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        //启动支付宝的客户端
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
