{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v5.0 (eol)
{
  aspnetcore_5_0 = buildAspNetCore {
    inherit icu;
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
    inherit icu;
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
    inherit icu;
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
    packages = { fetchNuGet }: [

    ];
  };
}
