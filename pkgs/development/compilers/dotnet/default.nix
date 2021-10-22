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

  # v6.0 (RC)

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.0-rc.2.21480.10";
    sha512 = {
      x86_64-linux = "d48895237644a3999663b2e16baa2303d8b77f66385a04d8edb5601fdffacce18b1b1318827d09f74f6b133ff2c179ef659bd21cf8460289b5f81f404fa8b326";
      aarch64-linux = "3a92e93a8cb0c186f1c4a822d46a37604bc470599dbcbe05a7f1ea7c7d1dd9c0e6571de524de8729d19d237078742a0b4e3a1daa11b5eb5f8cce74b69710ada4";
      x86_64-darwin = "ed1cad94acf207d0f18201af1e0e6c386466f94b8fd0474dc8d59f47d8f3c456f3a55de392dda126e0e1f4f934249b0e17b7b86f6bc7c510dc475324ee1395f0";
      aarch64-darwin = "688879db73aa6b7556da70907920f3e443dff54bf8624030352ed5ba3896cceda69040ef359dacf55d50cc52fc2c75057d259a1cc11a2258d4446ebbd2200820";
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.0-rc.2.21480.5";
    sha512 = {
      x86_64-linux = "45062417c6111af4d635868927e8f69d43f66c9e0f111cb71c1861eaf5ceda4aefa99d97c6ce3b13fac2bc7c57c435e6f8b2d43c51a3bb3304b42081d98f7047";
      aarch64-linux = "b0f8128d994b0de0c72b9dd8083a7350218adfafedc643c59b497fa605420602004d9e21e8acb488d92bc498f9783a3240cfcafa77443eb6f08b66aadc4f5b65";
      x86_64-darwin = "0f702645719af5a4f1e720c0f2a0c67c7a4a84fac525b3ac6ce6357ca6d44405aeca674d04d8a976a7338ddf8782350debd53dce85e614c837106ffadf84cfb9";
      aarch64-darwin = "747abb8eaad53e0ca7e5b2908b620076fa68a75c5e822361483ed13f7544e31def26bbf67bb85f47633e2dddde9cb095503bf70d1a4b0b2f33c6ef6f887d95fa";
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.100-rc.2.21505.57";
    sha512 = {
      x86_64-linux = "0a8f85a2757f61ca7f9b8c546af4554c2aac9cdb06f6d62879a60de6f2a3d37ea7136f48896c9c85828a2d55df354e7b9b5b4dc22896c927f0c6370a5ade1b9c";
      aarch64-linux = "14aa96f47f7f3520075e41753c705bdbf7f84fd7cff7cc2add1095a13e3e3c44eaaf2d822551902f05a6ad0c9acd7f7424190b7c09c397004c632eddc8acd5ac";
      x86_64-darwin = "6a896f2d1e8e2d00b52641e8b1aee88888a2b30e0f18e499b1eaf4ae7dbdaa24ea5af0dbd4a6a1cee715738e6e91cecdbc02c2c7d3d4c71d4c9af3e04f1b4fc9";
      aarch64-darwin = "c96c8a86e36ca16a0e10f635250472d5c8eda290dc505ed8eb4bd6a68b8e6ae6b2770236f5bda1573bc3124229531b3ed7dd71f60a821e39aaaa6697a82fdf8a";
    };
  };
}
