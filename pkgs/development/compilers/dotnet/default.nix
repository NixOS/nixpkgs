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
    version = "3.1.19";
    sha512 = {
      x86_64-linux = "c9234b5dba62c88b5f7e869c7dc7fc94d9cd7b300b0ed2461132c32762c0d3d1f23a1ee0432264704fefeb35f77ca7d1dd41910daee84df9aa325559a43cfc71";
      aarch64-linux = "4cba9b43a9beb977bb50c290c0e7cbbf42664538609079dd1bc0e925a0cc4a1f76748492d4d0d402610ae910e878449bab5d797a9f12e63399585b11f9bfbee9";
      x86_64-darwin = "a30959156c818d8d93df398742a70a050decfddbd777ddd6adb4d3c1aa5ed129545eab8f0aa3f12be991611dbc3582336ed747f3075906a2a29a1cd30ef3ad90";
    };
  };

  runtime_3_1 = buildNetRuntime {
    version = "3.1.19";
    sha512 = {
      x86_64-linux = "2cf268cc13bb4739203a18a9160aac58f2088e8ec275b1f7ef2fe2b74bc16edfdfbeb886a74fc9421edbf2899fa9e3ee7ea2734a83b1800b4a9848fb7e10bbbe";
      aarch64-linux = "c6a97bc6e2f2644d57d3fa5a512274b7129956371b07e0f39f734875b15bc0c178a9b068e2fa3e06e8a3a6696163ad1856f5d87a689612211ee02e589138110e";
      x86_64-darwin = "41ae9bc0212247c4721f41be384dae620971360c09fa31430f062c2ab851f10506ef620bf63ee414819b5dd20ddae8a1ce581bbe0d699378b244375e0822bd34";
    };
  };

  sdk_3_1 = buildNetSdk {
    version = "3.1.413";
    sha512 = {
      x86_64-linux = "2a0824f11aba0b79d3f9a36af0395649bc9b4137e61b240a48dccb671df0a5b8c2086054f8e495430b7ed6c344bb3f27ac3dfda5967d863718a6dadeca951a83";
      aarch64-linux = "39f198f07577faf81f09ca621fb749d5aac38fc05e7e6bd6226009679abc7d001454068430ddb34b320901955f42de3951e2707e01bce825b5216df2bc0c8eca";
      x86_64-darwin = "2c8e5b7e578aa36d40946d0deea93dff72a68ebb5504b1593d86d63022be8b65b284cf2adad711a926b7170fc865ac4cb38531a4f2ef087e07147e67300e86b8";
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
