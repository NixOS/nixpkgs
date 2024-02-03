/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_6_0 aspnetcore_7_0 ];

Hashes and urls are retrieved from:
https://dotnet.microsoft.com/download/dotnet
*/
{ lib, config, callPackage, recurseIntoAttrs }:
let
  buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
  buildAttrs = {
    buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
    buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
    buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
  };

  runtimeIdentifierMap = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "osx-x64";
    "aarch64-darwin" = "osx-arm64";
    "x86_64-windows" = "win-x64";
    "i686-windows" = "win-x86";
  };

  # Convert a "stdenv.hostPlatform.system" to a dotnet RID
  systemToDotnetRid = system: runtimeIdentifierMap.${system} or (throw "unsupported platform ${system}");

  pkgs = rec {
    inherit systemToDotnetRid;

    combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

    ## Files in versions/ are generated automatically by update.sh ##
    dotnet_6-bin = import ./versions/6.0.nix buildAttrs;
    dotnet_7-bin = import ./versions/7.0.nix buildAttrs;
    dotnet_8-bin = import ./versions/8.0.nix buildAttrs;
    dotnet_8_0_102-bin = import ./versions/8.0.102.nix buildAttrs;
    dotnet_9-bin = import ./versions/9.0.nix buildAttrs;

    dotnet_8 = recurseIntoAttrs (callPackage ./8 { bootstrapSdk = dotnet_8_0_102-bin.sdk; });
    dotnet_9 = recurseIntoAttrs (callPackage ./9 {});
  };

in
  pkgs // lib.optionalAttrs config.allowAliases (with pkgs; {
    sdk_2_1 = throw "Dotnet SDK 2.1 is EOL";
    sdk_2_2 = throw "Dotnet SDK 2.2 is EOL";
    sdk_3_0 = throw "Dotnet SDK 3.0 is EOL";
    sdk_3_1 = throw "Dotnet SDK 3.1 is EOL";
    sdk_5_0 = throw "Dotnet SDK 5.0 is EOL";
    aspnetcore_6_0 = dotnet_6-bin.aspnetcore;
    aspnetcore_7_0 = dotnet_7-bin.aspnetcore;
    aspnetcore_8_0 = dotnet_8-bin.aspnetcore;
    runtime_6_0 = dotnet_6-bin.runtime;
    runtime_7_0 = dotnet_7-bin.runtime;
    runtime_8_0 = dotnet_8-bin.runtime;
    sdk_6_0 = dotnet_6-bin.sdk;
    sdk_7_0 = dotnet_7-bin.sdk;
    sdk_8_0 = dotnet_8-bin.sdk;
  })
