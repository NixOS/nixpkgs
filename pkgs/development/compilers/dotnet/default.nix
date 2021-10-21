/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_5_0 aspnetcore_5_0 ];

Hashes below are retrived from:
https://dotnet.microsoft.com/download/dotnet
*/
{ callPackage }:
let
  buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
  buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
  buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
  buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
in
rec {
  combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

  # EOL

  sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 3.1 (LTS) or 5.0 (Current)";
  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1 (LTS) or 5.0 (Current)";
  sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 3.1 (LTS) or 5.0 (Current)";

  # v3.1 (LTS)

  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "f59252166dbfe11a78373226222d6a34484b9132e24283222aea8a950a5e9657da2e4d4e9ff8cbcc2fd7c7705e13bf42a31232a6012d1e247efc718e3d8e2df1";
      aarch64-linux = "f3d014431064362c29361e3d3b33b7aaaffe46e22f324cd42ba6fc6a6d5b712153e9ec82f10cf1bee416360a68fb4520dc9c0b0a8860316c4c9fce75f1adae80";
      x86_64-darwin = "477912671e21c7c61f5666323ad9e9c246550d40b4d127ccc71bcb296c86e07051e3c75251beef11806f198eebd0cd4b36790950f24c730dc6723156c0dc11b5";
    };
  };

  runtime_3_1 = buildNetRuntime {
    version = "3.1.21";
    sha512 = {
      x86_64-linux = "cc4b2fef46e94df88bf0fc11cb15439e79bd48da524561dffde80d3cd6db218133468ad2f6785803cf0c13f000d95ff71eb258cec76dd8eb809676ec1cb38fac";
      aarch64-linux = "80971125650a2fa0163e39a2de98bc2e871c295b723559e6081a3ab59d99195aa5b794450f8182c5eb4e7e472ca1c13340ef1cc8a5588114c494bbb5981f19c4";
      x86_64-darwin = "049257f680fe7dfb8e98a2ae4da6aa184f171b04b81c506e7a83509e46b1ea81ea6000c4d01c5bed46d5495328c6d9a0eeecbc0dc7c2c698296251fb04b5e855";
    };
  };

  sdk_3_1 = buildNetSdk {
    version = "3.1.415";
    sha512 = {
      x86_64-linux = "df7a6d1abed609c382799a8f69f129ec72ce68236b2faecf01aed4c957a40a9cfbbc9126381bf517dff3dbe0e488f1092188582701dd0fef09a68b8c5707c747";
      aarch64-linux = "7a5b9922988bcbde63d39f97e283ca1d373d5521cca0ab8946e2f86deaef6e21f00244228a0d5d8c38c2b9634b38bc7338b61984f0e12dd8fdb8b2e6eed5dd34";
      x86_64-darwin = "e26529714021d1828687c404dd0800c61eb267c9da62ee629b91f5ffa8af77d156911bd3c1a58bf11e5c589cfe4a852a95c14a7cb25f731e92a484348868964d";
    };
  };

  # v5.0 (Current)

  aspnetcore_5_0 = buildAspNetCore {
    version = "5.0.10";
    sha512 = {
      x86_64-linux = "60fd41e42e07a96416baf2dd7ea8112a7c7d510bc6f4656274981777d2cf5e824cd519924cdf06215338d74e78cdc7801e1b24c39b3d67cd2d1b3c6fee6474a9";
      aarch64-linux = "e86dd5b26e5add2f35c3a029c78e3c447755a319c105d371da297f66db5eff260f3f55ccf23e508e9a33536876708ac2e358dc62a4a28518f88df3a9131adb01";
      x86_64-darwin = "124abacba27e26249d265d51fd7abc7ab0bed9859ce3a6a8e4f193031bff3f28dd81af639542b0cc043a3957e2a90a2f5b41c6ec6b4a50a4cb8fce12bc8654f9";
    };
  };

  runtime_5_0 = buildNetRuntime {
    version = "5.0.10";
    sha512 = {
      x86_64-linux = "421b00d5751381e6bf829dcba8fa0d781f0efd065be492739d60a4bef2b7b362dbec77fa3289e2ee45cab40616f95318fc214699ffe2f33aa15e77c2d163841c";
      aarch64-linux = "30861f2bd41fcd7c1d657be1eafa09f22886af0c3e09d1854c626b675a469347ce9fb79b2ea92b5ed4e2fd3d3457766ac03fc5393a690099e1d2b9b15f3334b9";
      x86_64-darwin = "2839f4fafa1f85a90b43a74a4898cbba915324f7363f1716e58cb9163d1415fa4d360703e27d0cadfe8495a370ccddbcfcc514076a880d6343a0bff76bb5ac2a";
    };
  };

  sdk_5_0 = buildNetSdk {
    version = "5.0.401";
    sha512 = {
      x86_64-linux = "a444d44007709ceb68d8f72dec0531e17f85f800efc0007ace4fa66ba27f095066930e6c6defcd2f85cdedea2fec25e163f5da461c1c2b8563e5cd7cb47091e0";
      aarch64-linux = "770dcf18c08cd285934af61bedc06ffcc16a74115d15376f72376cdfbb4ab9cc9f53537ca1fe5d906b4b3c30b960ffe1404d6f7e01254091b4b9d288e9e972fa";
      x86_64-darwin = "eca773f407314123fd5b2017f68520c0647651f53e546583c4145b596c230c42898b3e56355cd5ace76b793df4aca3cd7ff9142718c86eedeabbabb70b393d0e";
    };
  };

  # v6.0

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.0";
    sha512 = {
      x86_64-linux = "6a1ae878efdc9f654e1914b0753b710c3780b646ac160fb5a68850b2fd1101675dc71e015dbbea6b4fcf1edac0822d3f7d470e9ed533dd81d0cfbcbbb1745c6c";
      aarch64-linux = "e61eade344b686180b8a709229d6b3180ea6f085523e5e4e4b0d23dd00cf9edce3e51a920c986b1bab7d04d8cab5aae219c3b533b6feb84b32a02810936859b0";
      x86_64-darwin = "76029272ff50fbf9fcc513109b98c0db5f74dbf970c1380be4dfac0dae7558824d68a167d0a8ceb39042ff4a7ca973cdcc15afed2d1ffef55b0adba8e40c9073";
      aarch64-darwin = "e459ddf33243d680baecc5378b9c4182daf42b8c36a9a996205d91146a614d048a385f953c43727350ad55b1221c5f5d43b383d03e3883e862bf12faeaa02dfb";
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.0";
    sha512 = {
      x86_64-linux = "7cc8d93f9495b516e1b33bf82af3af605f1300bcfeabdd065d448cc126bd97ab4da5ec5e95b7775ee70ab4baf899ff43671f5c6f647523fb41cda3d96f334ae5";
      aarch64-linux = "b0f0f2b4dc0a31b06cc3af541a3c44260317ca3a4414a5d50e6cf859d93821b3d2c2246baec9f96004aeb1eb0e353631283b11cf3acc134d4694f0ed71c9503d";
      x86_64-darwin = "d6842bddd9652dd7ad1d8156c3e9012f9412b3d89b4cfc0b6d644fd76744298aa5ed2cde8a80d14bb2b247ee162bae255875ee2ca62033a422dacb7adaeece2d";
      aarch64-darwin = "5cfc3c8a70f0e90f09047d3eeccd699e7210756b60fabbf1a30d6fdc121df084e5d8c3210557273739d5421f031dc9e4d07c611406734ca0671585de6e28e028";
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.100";
    sha512 = {
      x86_64-linux = "cb0d174a79d6294c302261b645dba6a479da8f7cf6c1fe15ae6998bc09c5e0baec810822f9e0104e84b0efd51fdc0333306cb2a0a6fcdbaf515a8ad8cf1af25b";
      aarch64-linux = "e5983c1c599d6dc7c3c7496b9698e47c68247f04a5d0d1e3162969d071471297bce1c2fd3a1f9fb88645006c327ae79f880dcbdd8eefc9166fd717331f2716e7";
      x86_64-darwin = "6e2f502a84f712d60daed31c4076c5b55ee98a03259adf4bdc01659afcac2be7050e5a404dcda35fdc598bf5cd766772c08abc483ed94f6985c9501057b0186a";
      aarch64-darwin = "92ead34c7e082dbed2786db044385ddfc68673e096a3edf64bc0bf70c76ea1c5cb816cde99aab2d8c528a44c86593b812877d075486dd0ae565f0e01e9eaa562";
    };
  };
}
