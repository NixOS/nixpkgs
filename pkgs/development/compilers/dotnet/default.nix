/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_3_1 sdk_5_0 aspnetcore_5_0 ];

Hashes and urls below are retrieved from:
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

  # v3.1 (lts)
  aspnetcore_3_1 = buildAspNetCore {
    version = "3.1.21";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c4565012-97e8-4a5a-9edf-8d6c94f0ac5c/dd227c01d532bcb731b026243a51f55f/aspnetcore-runtime-3.1.21-linux-x64.tar.gz";
        sha512  = "f59252166dbfe11a78373226222d6a34484b9132e24283222aea8a950a5e9657da2e4d4e9ff8cbcc2fd7c7705e13bf42a31232a6012d1e247efc718e3d8e2df1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5d245f70-4e8f-457a-9c4f-d4140136e496/56193e7de38e0f4101eb6f3fd2c60c41/aspnetcore-runtime-3.1.21-linux-arm64.tar.gz";
        sha512  = "f3d014431064362c29361e3d3b33b7aaaffe46e22f324cd42ba6fc6a6d5b712153e9ec82f10cf1bee416360a68fb4520dc9c0b0a8860316c4c9fce75f1adae80";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dd423a05-c133-464d-a117-d2e73d6dfeb5/a2d7c629802b8a283819a445a3024944/aspnetcore-runtime-3.1.21-osx-x64.tar.gz";
        sha512  = "477912671e21c7c61f5666323ad9e9c246550d40b4d127ccc71bcb296c86e07051e3c75251beef11806f198eebd0cd4b36790950f24c730dc6723156c0dc11b5";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    version = "3.1.21";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/286e526e-282b-47e5-afeb-4f99ee481972/495908d6a6019e47249bd05f8346aeb5/dotnet-runtime-3.1.21-linux-x64.tar.gz";
        sha512  = "cc4b2fef46e94df88bf0fc11cb15439e79bd48da524561dffde80d3cd6db218133468ad2f6785803cf0c13f000d95ff71eb258cec76dd8eb809676ec1cb38fac";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/45b3ad17-6ce6-4cd6-a975-d4f152203750/c6df44d802c52e65ad5d9c783ccd46ab/dotnet-runtime-3.1.21-linux-arm64.tar.gz";
        sha512  = "80971125650a2fa0163e39a2de98bc2e871c295b723559e6081a3ab59d99195aa5b794450f8182c5eb4e7e472ca1c13340ef1cc8a5588114c494bbb5981f19c4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3896eba4-4ef4-47a7-846c-8acb44b15feb/4920ee69b26772423edc686e499da061/dotnet-runtime-3.1.21-osx-x64.tar.gz";
        sha512  = "049257f680fe7dfb8e98a2ae4da6aa184f171b04b81c506e7a83509e46b1ea81ea6000c4d01c5bed46d5495328c6d9a0eeecbc0dc7c2c698296251fb04b5e855";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    version = "3.1.415";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6425056e-bfd5-48be-8b00-223c03a4d0f3/08a801489b7f18e9e73a1378082fbe66/dotnet-sdk-3.1.415-linux-x64.tar.gz";
        sha512  = "df7a6d1abed609c382799a8f69f129ec72ce68236b2faecf01aed4c957a40a9cfbbc9126381bf517dff3dbe0e488f1092188582701dd0fef09a68b8c5707c747";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4a78a923-e891-40fe-88d2-4bff2c90519f/126bee4399caeabde4f34f4ace7f44e3/dotnet-sdk-3.1.415-linux-arm64.tar.gz";
        sha512  = "7a5b9922988bcbde63d39f97e283ca1d373d5521cca0ab8946e2f86deaef6e21f00244228a0d5d8c38c2b9634b38bc7338b61984f0e12dd8fdb8b2e6eed5dd34";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7d663efa-2180-4562-8735-be11d8ba465d/605910e63a687d8c9e72ba108ffb1da4/dotnet-sdk-3.1.415-osx-x64.tar.gz";
        sha512  = "e26529714021d1828687c404dd0800c61eb267c9da62ee629b91f5ffa8af77d156911bd3c1a58bf11e5c589cfe4a852a95c14a7cb25f731e92a484348868964d";
      };
    };
  };

  # v5.0 (current)
  aspnetcore_5_0 = buildAspNetCore {
    version = "5.0.12";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ad0a54ca-4b88-4762-a790-aebeaba6b9e7/0f796fb90696d078046d90d8a05c027e/aspnetcore-runtime-5.0.12-linux-x64.tar.gz";
        sha512  = "0529f23ffa651ac2c2807b70d6e5034f6ae4c88204afdaaa76965ef604d6533f9440d68d9f2cdd3a9f2ca37e9140e6c61a9f9207d430c71140094c7d5c33bf79";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bfc8ae06-2830-4082-a09e-63b3c7134096/880a4712d4ba3491c88aa566553c4e8a/aspnetcore-runtime-5.0.12-linux-arm64.tar.gz";
        sha512  = "70570177896943613f0cddeb046ffccaafb1c8245c146383e45fbcfb27779c70dff1ab22c2b13a14bf096173c9279e0a386f61665106a3abb5f623b50281a652";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/06d71ed5-0755-40d6-8b8e-14a24b8a9cb7/47a8b4deda0deecf3658716b642c69bf/aspnetcore-runtime-5.0.12-osx-x64.tar.gz";
        sha512  = "bd9e7dd7f48c220121dde85b3acc4ce7eb2a1944d472f9340276718ef72d033f05fd9a62ffb9de93b8e7633843e731ff1cb5e8c836315f7571f519fdb0a119e1";
      };
    };
  };

  runtime_5_0 = buildNetRuntime {
    version = "5.0.12";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/781b7ae6-166c-4114-97f8-926d2bf74d34/fe51479e3138d672c512ef0322be23d3/dotnet-runtime-5.0.12-linux-x64.tar.gz";
        sha512  = "32b5f86db3b1d4c21e3cf616d22f0e4a7374385dac0cf03cdebf3520dcf846460d9677ec1829a180920740a0237d64f6eaa2421d036a67f4fe9fb15d4f6b1db9";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7c342ad2-2dae-471b-ae46-c0c820321c1f/a480ad8ca0bc826a48c9b1e56efd972b/dotnet-runtime-5.0.12-linux-arm64.tar.gz";
        sha512  = "a8089fad8d21a4b582aa6c3d7162d56a21fee697fd400f050a772f67c2ace5e4196d1c4261d3e861d6dc2e5439666f112c406104d6271e5ab60cda80ef2ffc64";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8f990fa6-6b13-40ad-95f6-383391ff3d91/7531048d16c01efdf3885da367aa8b89/dotnet-runtime-5.0.12-osx-x64.tar.gz";
        sha512  = "a3160eaec15d0e2b62a4a2cdbb6663ef2e817fd26a3a3b8b3d75c5e3538b2947ff66eaddafb39cc297b9f087794d5fbd5a0e097ec8522ab6fea562f230055264";
      };
    };
  };

  sdk_5_0 = buildNetSdk {
    version = "5.0.403";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b77183fa-c045-4058-82c5-d37742ed5f2d/ddaccef3e448a6df348cae4d1d271339/dotnet-sdk-5.0.403-linux-x64.tar.gz";
        sha512  = "7ba5f7f898dba64ea7027dc66184d60ac5ac35fabe750bd509711628442e098413878789fad5766be163fd2867cf22ef482a951e187cf629bbc6f54dd9293a4a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/91015c72-ce5a-4840-9e87-5bfa4bb80224/b39692ac418d790ff7a2e092eb07de98/dotnet-sdk-5.0.403-linux-arm64.tar.gz";
        sha512  = "6cc705fe45c0d8df6a493eb2923539ef5b62d048d5218859bf3af06fb3934c9c716c16f98ee1a28c818d77adff8430bf39a2ae54a59a1468b704b4ba192234ac";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5ccdb916-531f-4064-84e8-5475b273a4de/80dcfa0c2eb528f8b0e7c313ed36f4f1/dotnet-sdk-5.0.403-osx-x64.tar.gz";
        sha512  = "70beea069db182cca211cf04d7a80f3d6a3987d76cbd2bb60590ee76b93a4041b1b86ad91057cddbbaddd501c72327c1bc0a5fec630f38063f84bd60ba2b4792";
      };
    };
  };

  # v6.0 (lts)
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/de3f6658-5d5b-4986-aeb1-7efdf5818437/7df572051df15117a0f52be1b79e1823/aspnetcore-runtime-6.0.4-linux-x64.tar.gz";
        sha512  = "eaff93db0a4cc0adc2fc54de5e9a6e4b0844398451c06bcf6b2867471b8ed4fd0528ad04fe7150aa5ed306d5e08a5e4219c6029b96da03ad2d1c58e7a0ddacaf";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ba1662bf-50e6-451a-957f-0d55bc6e5713/921fe0e68428ac47c098e97418d3126a/aspnetcore-runtime-6.0.4-linux-arm64.tar.gz";
        sha512  = "18ffa72b38dcd01bbfd9f656996e994dbcdb7b6b196771fc498bbaea774ad844f7fd5418487d0a5a7f83a76b3683f8913e22275bc25d66ee0c0d84ea4e279971";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b39aa0b4-27e2-4fce-bf36-fb6d46f89e5e/6b8ca3b4c7026db460df1d49f5366f1b/aspnetcore-runtime-6.0.4-osx-x64.tar.gz";
        sha512  = "33b1b24496296242dd78714564e52e6be575f46d681a5093a0aca842aff5e29778cbf31259f11ce395fc9a2368fa6bfde2e12a074ccf310f9b661c0bdaf39d2d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d7b60e75-6901-4f68-8943-ce32cadeaf29/f14e40b3e9a69cbd79d47375b16a76e7/aspnetcore-runtime-6.0.4-osx-arm64.tar.gz";
        sha512  = "9ff8ecc60f70d8cfa53396761610282358aa7bcbd3f013aedc639be7b8f502a8cb121777c7e8a0a7d64d74b99211751ea8a8c1819861b72ad11d80590ba9ed2b";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5b08d331-15ac-4a53-82a5-522fa45b1b99/65ae300dd160ae0b88b91dd78834ce3e/dotnet-runtime-6.0.4-linux-x64.tar.gz";
        sha512  = "001487bfb337d0f737c4e3dedc4bc41b3185922c07c07e8f1d47e4578914fdeeed7421d7af2c4bb5e17ebddd05fde4cb9aea1e8145018dcffeaca70c1fa49bbb";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3641affa-8bb0-486f-93d9-68adff4f4af7/1e3df9fb86cba7299b9e575233975734/dotnet-runtime-6.0.4-linux-arm64.tar.gz";
        sha512  = "acbb50f2a1cde2bb8f59ec2059cd90f669748ce0da519ddbb831d8f279c4b896cc7a8f4275fb2c4726c5caf3d6430ee6d9823baa6f65238c7017ecbc2b8a6444";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c0bc0428-852d-4884-b536-3d0969a400ba/fe0a9a221c3e665e88b7020633f2cf8e/dotnet-runtime-6.0.4-osx-x64.tar.gz";
        sha512  = "7a798ce54880533151cc9290129e1a6224e81e657026e5be580ee24742d54e8e8e5f8f3bdee2cb94d5129082e3a2ffd1460f490abb848aaf3558e584e2e2df43";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dd2f6b72-bf47-4ae5-8a3d-4d394569cc34/87d408439ac5feffe2abf622dbfa5084/dotnet-runtime-6.0.4-osx-arm64.tar.gz";
        sha512  = "3070af5d9dc44820dc93ca89489f1dfa8024958f64a9d62fafddb49fa16325f0845cc53027703495dc524515e613f3e7701ef148da06653070cb2e3928fb0aca";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.202";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9d8c7137-2091-4fc6-a419-60ba59c8b9de/db0c5cda94f31d2260d369123de32d59/dotnet-sdk-6.0.202-linux-x64.tar.gz";
        sha512  = "81e9c368d445d9e92e3af471d52dc2aa05e3ecb75ce95c13a2ed1d117852dae43d23d913bbe92eab730aef7f38a14488a1ac65c3b79444026a629647322c5798";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/952f5525-7227-496f-85e5-09cadfb44629/eefd0f6eb8f809bfaf4f0661809ed826/dotnet-sdk-6.0.202-linux-arm64.tar.gz";
        sha512  = "2d0021bb4cd221ffba6888dbd6300e459f45f4f9d3cf7323f3b97ee0f093ef678f5a36d1c982296f4e15bbcbd7275ced72c3e9b2fc754039ba663d0612ffd866";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1a014dee-ff5f-48e3-a817-82b9bd536b56/fed3a710f5e0add13844a6ce400775a1/dotnet-sdk-6.0.202-osx-x64.tar.gz";
        sha512  = "ff7df20ce9054ed50d521eba88e063422efa4d48cb3117cf733cc6ecea24012c2ac34f6df10d88f64fe7a952bb96455a3c2eb877f1d50c0b7bcaedf11f98ce82";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/032fc69b-f437-4d17-9e6c-c204ce18a0b0/76386390762a9ba205666a6e45a2ac47/dotnet-sdk-6.0.202-osx-arm64.tar.gz";
        sha512  = "8bf9ff3f89ac0f2d04b09d3f5df72efeac8007b9e33980c9c80eb735d050275a5594b11d902d0304ac9967111971bcd690be3adf34d4acbef6d247e8f2071f60";
      };
    };
  };
}
