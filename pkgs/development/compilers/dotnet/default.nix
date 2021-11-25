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

  sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";
  sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 3.1 (LTS), 5.0 (Current) or 6.0 (LTS)";

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
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "0529f23ffa651ac2c2807b70d6e5034f6ae4c88204afdaaa76965ef604d6533f9440d68d9f2cdd3a9f2ca37e9140e6c61a9f9207d430c71140094c7d5c33bf79";
      aarch64-linux = "70570177896943613f0cddeb046ffccaafb1c8245c146383e45fbcfb27779c70dff1ab22c2b13a14bf096173c9279e0a386f61665106a3abb5f623b50281a652";
      x86_64-darwin = "bd9e7dd7f48c220121dde85b3acc4ce7eb2a1944d472f9340276718ef72d033f05fd9a62ffb9de93b8e7633843e731ff1cb5e8c836315f7571f519fdb0a119e1";
    };
  };

  runtime_5_0 = buildNetRuntime {
    version = "5.0.12";
    sha512 = {
      x86_64-linux = "32b5f86db3b1d4c21e3cf616d22f0e4a7374385dac0cf03cdebf3520dcf846460d9677ec1829a180920740a0237d64f6eaa2421d036a67f4fe9fb15d4f6b1db9";
      aarch64-linux = "a8089fad8d21a4b582aa6c3d7162d56a21fee697fd400f050a772f67c2ace5e4196d1c4261d3e861d6dc2e5439666f112c406104d6271e5ab60cda80ef2ffc64";
      x86_64-darwin = "a3160eaec15d0e2b62a4a2cdbb6663ef2e817fd26a3a3b8b3d75c5e3538b2947ff66eaddafb39cc297b9f087794d5fbd5a0e097ec8522ab6fea562f230055264";
    };
  };

  sdk_5_0 = buildNetSdk {
    version = "5.0.403";
    sha512 = {
      x86_64-linux = "7ba5f7f898dba64ea7027dc66184d60ac5ac35fabe750bd509711628442e098413878789fad5766be163fd2867cf22ef482a951e187cf629bbc6f54dd9293a4a";
      aarch64-linux = "6cc705fe45c0d8df6a493eb2923539ef5b62d048d5218859bf3af06fb3934c9c716c16f98ee1a28c818d77adff8430bf39a2ae54a59a1468b704b4ba192234ac";
      x86_64-darwin = "70beea069db182cca211cf04d7a80f3d6a3987d76cbd2bb60590ee76b93a4041b1b86ad91057cddbbaddd501c72327c1bc0a5fec630f38063f84bd60ba2b4792";
    };
  };

  # v6.0 (LTS)

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
