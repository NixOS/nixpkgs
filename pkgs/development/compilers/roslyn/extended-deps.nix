# Some required nuget packages are not picked up by the deps generation script,
# since they are referenced as a SDK reference, which unfortunately only gets
# downloaded during build time. So we include them manually.
{ fetchNuGet }: (import ./deps.nix { inherit fetchNuGet; }) ++ [
  (fetchNuGet rec {
    pname = "Microsoft.DotNet.Arcade.Sdk";
    version = "7.0.0-beta.22171.2";
    url = "https://pkgs.dev.azure.com/dnceng/9ee6d478-d288-47f7-aacc-f6e6d082ae6d/_packaging/1a5f89f6-d8da-4080-b15f-242650c914a8/nuget/v3/flat2/microsoft.dotnet.arcade.sdk/${version}/microsoft.dotnet.arcade.sdk.${version}.nupkg";
    sha256 = "15y26skavivkwhnpfa984if3cnpnllbbwbdsjiyfdcalp32fhmjq";
  })
]
