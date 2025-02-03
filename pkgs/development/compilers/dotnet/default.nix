/*
How to combine packages for use in development:
dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_6_0 aspnetcore_7_0 ];

Hashes and urls are retrieved from:
https://dotnet.microsoft.com/download/dotnet
*/
{ lib
, config
, recurseIntoAttrs
, generateSplicesForMkScope
, makeScopeWithSplicing'
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "dotnetCorePackages";
  f = (self:
    let
      callPackage = self.callPackage;

      buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) {};
      buildAttrs = {
        buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
        buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
        buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
      };

      ## Files in versions/ are generated automatically by update.sh ##
      dotnet_6_0 = import ./versions/6.0.nix buildAttrs;
      dotnet_7_0 = import ./versions/7.0.nix buildAttrs;
      dotnet_8_0 = import ./versions/8.0.nix buildAttrs;
      dotnet_9_0 = import ./versions/9.0.nix buildAttrs;

      runtimeIdentifierMap = {
        "x86_64-linux" = "linux-x64";
        "aarch64-linux" = "linux-arm64";
        "x86_64-darwin" = "osx-x64";
        "aarch64-darwin" = "osx-arm64";
        "x86_64-windows" = "win-x64";
        "i686-windows" = "win-x86";
      };

    in {
      inherit callPackage;

      # Convert a "stdenv.hostPlatform.system" to a dotnet RID
      systemToDotnetRid = system: runtimeIdentifierMap.${system} or (throw "unsupported platform ${system}");

      combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) {};

      patchNupkgs = callPackage ./patch-nupkgs.nix {};
      nugetPackageHook = callPackage ./nuget-package-hook.nix {};

      buildDotnetModule = callPackage ../../../build-support/dotnet/build-dotnet-module { };
      buildDotnetGlobalTool = callPackage ../../../build-support/dotnet/build-dotnet-global-tool { };

      mkNugetSource = callPackage ../../../build-support/dotnet/make-nuget-source { };
      mkNugetDeps = callPackage ../../../build-support/dotnet/make-nuget-deps { };
      addNuGetDeps = callPackage ../../../build-support/dotnet/add-nuget-deps { };
      fetchNupkg = callPackage ../../../build-support/dotnet/fetch-nupkg { };

      dotnet_8 = recurseIntoAttrs (callPackage ./8 { bootstrapSdk = dotnet_8_0.sdk_8_0_1xx; });
      dotnet_9 = recurseIntoAttrs (callPackage ./9 {});
    } // lib.optionalAttrs config.allowAliases {
      # EOL
      sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 6.0 (LTS) or 7.0 (Current)";
      sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 6.0 (LTS) or 7.0 (Current)";
      sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 6.0 (LTS) or 7.0 (Current)";
      sdk_3_1 = throw "Dotnet SDK 3.1 is EOL, please use 6.0 (LTS) or 7.0 (Current)";
      sdk_5_0 = throw "Dotnet SDK 5.0 is EOL, please use 6.0 (LTS) or 7.0 (Current)";
    } // dotnet_6_0 // dotnet_7_0 // dotnet_8_0 // dotnet_9_0);
}
