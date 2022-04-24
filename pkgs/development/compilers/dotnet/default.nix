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
    version = "6.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3af854b6-80fb-425a-972f-c7f0d693bf1b/cd458a4feae5a98646ee12a14ab34151/aspnetcore-runtime-6.0.3-linux-x64.tar.gz";
        sha512  = "9ea54220468d922ef2c40433c4b8c70df6c60d8ea63a3ac1ff5e5ce712606ae5cfe1e57d321b87eff1b5dc34d7823a4b4b964180587383f22d9a0ff5bb3a8c88";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1e7933b2-1202-4aeb-bb70-a6f9cecac61a/b12b5666b3d4cf508f8575581abd4033/aspnetcore-runtime-6.0.3-linux-arm64.tar.gz";
        sha512  = "745586b64d3e01f856c366821f6fb8ca97c55b2a90ba36d528fdf99c98938574805153e7d4fff0560afe8382bea14b35ddeba391a2dc2328285f02e125c9b702";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2cfe2a02-dd59-4cb7-9788-76c620eaa0ff/dfd0d449289a042be9bc62e4466bf350/aspnetcore-runtime-6.0.3-osx-x64.tar.gz";
        sha512  = "bda83cf36fc9aa62ff3e16a26b5f8f37efa3221ab826467fe26f3072517a428c64e44bc52f8a90f5c77bc60eeeddb8c3d59d2a509999edce3b51b835dd7edf83";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d7cf4456-d9ba-4a31-98e9-4681e1b0d8b8/b9c4cfded00e9940756e62c4486f64c6/aspnetcore-runtime-6.0.3-osx-arm64.tar.gz";
        sha512  = "03d1d4e8a8370856120e045ed4a83b3383d00fb56b5fdaf7db0de8bab5e3de60d03c02deaed6f72bde0d6b0e12511fe1202c4e2c25fdeeb489ad61a5902d71d3";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4e766615-57e6-4b1d-a574-25eeb7a71107/9f95f74c33711e085302ffd644ef86ee/dotnet-runtime-6.0.3-linux-x64.tar.gz";
        sha512  = "083d9e6e72f0d8f175b341f5229277374e630c5358cfd3602fe611aeef59abec715edbe18d62135a5d13a650e99ef49f19b17e8c81663d0b5bee757519bec894";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/89b5d16e-cb5e-4e6c-90f6-7332e93d20ae/7a0146aa4fc59154a3256c5196a622c7/dotnet-runtime-6.0.3-linux-arm64.tar.gz";
        sha512  = "f0f9fb191054dea2e4151a86c3de1a11ce574cc843cde429850db0996c7df403dfa348a277f1af96f13fec718ae77f3be75379ed3829b027e561564ff22c7258";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1f354e35-ff3f-4de7-b6be-f5001b7c3976/b7c8814ab28a6f00f063440e63903105/dotnet-runtime-6.0.3-osx-x64.tar.gz";
        sha512  = "98c457cbc0ac8f5f0acd7807bb45726b78e87d4f554fd30123cc8d9568b5341cc5bba16c8e4c85537ec4798d7e4d7f2f11701d2045b124f1b36bca75d80458e8";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/03047609-269e-4ca6-bf2e-406c496b27e3/3b19ad4d3fbc5d9a92f436db13e9e3d1/dotnet-runtime-6.0.3-osx-arm64.tar.gz";
        sha512  = "1debd4acab3c6408c849323e6dfba28a626850c40f93a0debe46c54f0c0b39526f4118d5b2bcf0307efeba0bc2656a92187a685400095ae078227698a0aabfb3";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.201";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c505a449-9ecf-4352-8629-56216f521616/bd6807340faae05b61de340c8bf161e8/dotnet-sdk-6.0.201-linux-x64.tar.gz";
        sha512  = "a4d96b6ca2abb7d71cc2c64282f9bd07cedc52c03d8d6668346ae0cd33a9a670d7185ab0037c8f0ecd6c212141038ed9ea9b19a188d1df2aae10b2683ce818ce";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/33c6e1e3-e81f-44e8-9de8-91934fba3c94/9105f95a9e37cda6bd0c33651be2b90a/dotnet-sdk-6.0.201-linux-arm64.tar.gz";
        sha512  = "2ea443c27ab7ca9d566e4df0e842063642394fd22fe2a8620371171c8207ae6a4a72c8c54fc6af5b6b053be25cf9c09a74504f08b963e5bd84544619aed9afc2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cecaa095-3254-4987-b105-6bb9b594a89c/df29881aea827565a96d5e47dc337749/dotnet-sdk-6.0.201-osx-x64.tar.gz";
        sha512  = "1df27ca5a1db1a8712acd95083aa00ec7b266618770e164d6460d0cf781b3643a7365ef35232140c83b588f7aa4e2d7e5f5b6d627f1851b2d0ec197172f9fb4d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/628be5e6-7fc7-42b6-99c9-ea46fbcc3d14/d94bb4198af2d5013c75b1c70751ec8f/dotnet-sdk-6.0.201-osx-arm64.tar.gz";
        sha512  = "0796a81339788fbc160885548983889dcffd26a5c0ac935b497b290ae99920386f3929cebfbef9bb22f644a207ba329cf8b90ffe7bbb49d1d99d0d8a05ce50c9";
      };
    };
  };
}
