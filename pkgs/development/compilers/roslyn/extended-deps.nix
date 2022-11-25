# Some required nuget packages are not picked up by the deps generation script,
# since they are referenced as a SDK reference, which unfortunately only gets
# downloaded during build time. So we include them manually.
{ fetchNuGet }: (import ./deps.nix { inherit fetchNuGet; }) ++ [
  (fetchNuGet {
    pname = "Microsoft.DotNet.Arcade.Sdk";
    version = "1.0.0-beta.21072.7";
    url = "https://pkgs.dev.azure.com/dnceng/9ee6d478-d288-47f7-aacc-f6e6d082ae6d/_packaging/1a5f89f6-d8da-4080-b15f-242650c914a8/nuget/v3/flat2/microsoft.dotnet.arcade.sdk/1.0.0-beta.21072.7/microsoft.dotnet.arcade.sdk.1.0.0-beta.21072.7.nupkg";
    sha256 = "0bzgwdf9cm8ji08qd9i4z191igkgmf1cjzbdhcwxqd7pgalj7cwq";
  })
]
