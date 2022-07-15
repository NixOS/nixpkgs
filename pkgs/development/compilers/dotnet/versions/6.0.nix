{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/98271725-1784-407c-841a-64d87c674512/b433af33506c816e3b5838f5c65d990a/aspnetcore-runtime-6.0.7-linux-x64.tar.gz";
        sha512  = "d210e2afd009746d2c4d98c07077b89ce174f462c2bdaae9afea107a5b1c9c4ab63460ae3d9ae38c5388f591c0a95d8712359326013b23325b7be19b51835455";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b79c5fa9-a08d-4534-9424-4bacfc3cdc3d/449179d6fe8cda05f52b7be0f6828eb0/aspnetcore-runtime-6.0.7-linux-arm64.tar.gz";
        sha512  = "0c7317d2170f2632afd7c7c3e5bd84075071802e901de1ed5e54178f8a56266fe0770ebd84502aff9384b06908d4d5bee9d464d215fb20d841de177174f55f93";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5b4d2b0e-607e-4f9a-944f-0acdefd828d9/79a0271038df505617ef800587a92858/aspnetcore-runtime-6.0.7-osx-x64.tar.gz";
        sha512  = "6c05250d2affb61a1f34ba297e3c9bd0ddc42d64b1580f5e8cfa218a079cc455aa183f683869ba52e7b9ce58fb223dff8ef9776d4b2e2421ed7e2058d4af0750";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d952783-f61f-4399-841a-fa5b5aeffded/15580a465dec6a7c67107e3f96d6da13/aspnetcore-runtime-6.0.7-osx-arm64.tar.gz";
        sha512  = "4d9dccaeabc1490fb9261f0be0702c2f5b4e96b840edee94d50f9a4655aa4d85bcf5a16d21d43b0a543e5a90cc631510aba35000df465a4ffc6cca7de37907fc";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd828687-1706-4041-a804-5e93631fe256/d4ec75936459a7e8c772c929edcbfeda/dotnet-runtime-6.0.7-linux-x64.tar.gz";
        sha512  = "996bdaf33be0a9c0f1e2d309b997e3a84a31e28d2424853d7fb1600212f4ce600ebe1b9615de5e46c17652f08ad0d7ecd4b3619217c9624b875a26a553f370d8";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f9706e92-c7a1-4dc8-806a-0e95827c5b02/23be52946e4e2425c798208c5f16bb64/dotnet-runtime-6.0.7-linux-arm64.tar.gz";
        sha512  = "a63e100fe80cb64febfd2920e4065b3cc99f759c3de0897928a42cf14fdc963df324bef1354a7734420078d16e52fd8257dd480da465d865c4349c29cab1ef91";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/97def016-12c7-4e24-b924-772485a41faa/e96d9a0502492efa7de3897467f5972c/dotnet-runtime-6.0.7-osx-x64.tar.gz";
        sha512  = "9c53d16971f0366d6d69fbfe37e92eea806faa1c3502cc1050c0e6d2cf394cf886761146e344862a30d0cb131105f387c05d8ea207be8aa87c81cd4c8f962110";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/044c6d0f-0ac2-450f-b621-637ca24ab2fb/5cd0c43804f3fde6d09cacbfd8525868/dotnet-runtime-6.0.7-osx-arm64.tar.gz";
        sha512  = "9f08a535921df7c1ce837ef27478f2381e8132a9ebfec7630465fb3243ef2ec9e982d008faec69e0899675dc3a50b379a96967d1eed3c04dada40cb211489127";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.302";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e83f50a-0619-45e6-8f16-dc4f41d1bb16/e0de908b2f070ef9e7e3b6ddea9d268c/dotnet-sdk-6.0.302-linux-x64.tar.gz";
        sha512  = "ac1d124802ca035aa00806312460b371af8e3a55d85383ddd8bb66f427c4fabae75b8be23c45888344e13b283a4f9c7df228447c06d796a57ffa5bb21992e6a4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/33389348-a7d7-41ae-850f-ec46d3ca9612/36bad11f948b05a4fa9faac93c35e574/dotnet-sdk-6.0.302-linux-arm64.tar.gz";
        sha512  = "26e98a63665d707b1a7729f1794077316f9927edd88d12d82d0357fe597096b0d89b64a085fcdf0cf49807a443bbfebb48e10ea91cea890846cf4308e67c4ea5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/60719796-b5c5-46dc-a26a-7e8126a292c8/a7b871d6c46136b61c30403d085ef97c/dotnet-sdk-6.0.302-osx-x64.tar.gz";
        sha512  = "003a06be76bf6228b4c033f34773039d57ebd485cf471a8117f5516f243a47a24d1b485ab9307becc1973107bb1d5b6c3028bbcbb217cbb42f5bee4c6c01c458";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/01a17a2d-6b92-4521-97a2-ad7d845a8064/44aa4e10f71e70a38b5f6f59d211cbab/dotnet-sdk-6.0.302-osx-arm64.tar.gz";
        sha512  = "59caea897a56b785245dcd3a6082247aeb879c39ecfab16db60e9dc3db447ca4e3ebe68e992c0551af886cd81f6f0088cb1433f1be6df865afa357f90f37ccf6";
      };
    };
  };
}
