{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (maintenance)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.26";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6f72adf7-0e78-48ea-85ef-e72a39a1f8a1/1ec0238c236c3757e5628563a329fdc4/aspnetcore-runtime-3.1.26-linux-x64.tar.gz";
        sha512  = "8bbf06012cdd2cff23c592e0d3c49d032d77add4dda8fba1d7ba73e6cc4ae97b1676908b14cdc7fc2fe723302e1efd27a44b48190a91d69c0e41bb5edb47501f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6b68a14a-b4dd-4a75-bb32-26c08d19190f/1d6b637e290775f668701f8f6092ab35/aspnetcore-runtime-3.1.26-linux-arm64.tar.gz";
        sha512  = "757ff6cbc31b1c8743077288d7fa621c73fa7f4d155d636ad100cda6e1f601e31d2f842d5cfef3dec5daa4c8c3efbcf76f02afd1c518cae7b67b2a46a9faab08";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/33e8be5c-5e6a-4dc2-9aa8-846aaffa6897/fe9d96af1d75f8d5f4cba4bff95f2fae/aspnetcore-runtime-3.1.26-osx-x64.tar.gz";
        sha512  = "0657d8b11a58357f5374e5d8201b401e55f9f4710794be565f7b9022d10639c2e72aebc6b7433b34fd24a03e8e12541c998fad28b5263de4439b3d31a8252c4c";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.26";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a14c8e4d-a22b-47f8-953c-bb4337634513/58017d103d432f7106c44b0891936aba/dotnet-runtime-3.1.26-linux-x64.tar.gz";
        sha512  = "03676885ec4d1f5ba184678a6b774f8e385abfff800a6bcee6f85557b39e9cdde500be49b5d6c956fc95cdfb9f33d31e467548bb498a52bc4fd639b3cb87c8d0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cb0e8b4b-7b2b-40cc-b7a6-30f0d4fabe6c/f5cb06cbb1b1b5d198792333b3db235a/dotnet-runtime-3.1.26-linux-arm64.tar.gz";
        sha512  = "574409616f5cbef35a2bd6fd1a2f0bcb3bdaa81457aea3af5e0e237ba768ced5214c51a3045697fe7478e8211e2045fc2072e382d6f456509a8f2923e9b1fc26";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6bedea65-b104-45b8-abe9-36cefbeedadf/05f4e472ec2395dad7103fda9ed278b2/dotnet-runtime-3.1.26-osx-x64.tar.gz";
        sha512  = "7957b5e697db7548964c399197ae8e61cc31f15374df384b6db9b47472a7d6f1b5b3e256c191e203c4d18c18cc8bdb6c4a331c5875bd37bd6415f3c83b8062da";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.420";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5424da8c-ce12-46de-a51a-8fa61aefdde6/52a9d6b5718ea40863db96901c780d4b/dotnet-sdk-3.1.420-linux-x64.tar.gz";
        sha512  = "b3bdd964182f9edc3c2976541e657fcc43b0eaf9bc97197597c7ecb8b784d79e3efb9e0405c84e1dcb434cf4cd38ddc4af628c5df486c3d7ae8a23e5254796e3";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a84bf296-ee6e-4e66-9694-90d3da7af2b4/b00b2efe2432938e5a19c45d3759d80f/dotnet-sdk-3.1.420-linux-arm64.tar.gz";
        sha512  = "ac66b1544fe178153bb85c2e5be584464374ce4c036fc95720547c231c2730312018fbdfc735f9071579749415bc54e1f6b8f080cc2b08d5799a0da941e8a5f5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bb0efe58-450c-4e28-81c1-4081acd6ffa4/1d0eaf8b624dff000c8b10ea0497e731/dotnet-sdk-3.1.420-osx-x64.tar.gz";
        sha512  = "370cba4685e07d1cdb5d7f9b754812b237802ace679c9b9985c6e5c4dc09f500580f1413679a288615079bd155b68b362adb00151b2b8f5ca7c3718ab9e16194";
      };
    };
    packages = { fetchNuGet }: [

    ];
  };
}
