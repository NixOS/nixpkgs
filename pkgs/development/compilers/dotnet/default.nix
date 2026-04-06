/*
  How to combine packages for use in development:
  dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_9_0 aspnetcore_8_0 ];

  Hashes and urls are retrieved from:
  https://dotnet.microsoft.com/download/dotnet
*/
{
  lib,
  config,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  writeScriptBin,
}:

let
  scope = makeScopeWithSplicing' {
    otherSplices = generateSplicesForMkScope "dotnetCorePackages";
    f = (
      self:
      let
        callPackage = self.callPackage;

        fetchNupkg = callPackage ../../../build-support/dotnet/fetch-nupkg { };

        buildDotnetSdk =
          let
            buildDotnet = attrs: callPackage (import ./binary/build-dotnet.nix attrs) { };
          in
          version:
          import version {
            inherit fetchNupkg;
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

      in
      {
        inherit
          callPackage
          fetchNupkg
          buildDotnetSdk
          ;

        generate-dotnet-sdk = writeScriptBin "generate-dotnet-sdk" (
          # Don't include current nixpkgs in the exposed version. We want to make the script runnable without nixpkgs repo.
          builtins.replaceStrings [ " -I nixpkgs=./." ] [ "" ] (builtins.readFile ./binary/update.sh)
        );

        # Convert a "stdenv.hostPlatform.system" to a dotnet RID
        systemToDotnetRid =
          system: runtimeIdentifierMap.${system} or (throw "unsupported platform ${system}");

        combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) { };

        patchNupkgs = callPackage ./patch-nupkgs.nix { };
        nugetPackageHook = callPackage ./nuget-package-hook.nix { };
        autoPatchcilHook = callPackage ../../../build-support/dotnet/auto-patchcil-hook { };

        buildDotnetModule = callPackage ../../../build-support/dotnet/build-dotnet-module { };
        buildDotnetGlobalTool = callPackage ../../../build-support/dotnet/build-dotnet-global-tool { };

        mkNugetSource = callPackage ../../../build-support/dotnet/make-nuget-source { };
        mkNugetDeps = callPackage ../../../build-support/dotnet/make-nuget-deps { };
        addNuGetDeps = callPackage ../../../build-support/dotnet/add-nuget-deps { };
      }
    );
  };

  callPackage = scope.callPackage;

  pkgs =
    scope
    // (
      let
        dotnet_6 = callPackage ./dotnet.nix {
          channel = "6.0";
          withVMR = false;
        };

        dotnet_7 = callPackage ./dotnet.nix {
          channel = "7.0";
          withVMR = false;
        };

        dotnet_8 = callPackage ./dotnet.nix {
          channel = "8.0";
        };

        dotnet_9 = callPackage ./dotnet.nix {
          channel = "9.0";
        };

        dotnet_10 = callPackage ./dotnet.nix {
          channel = "10.0";
        };

        dotnet_11 = callPackage ./dotnet.nix {
          channel = "11.0";
        };
      in
      lib.optionalAttrs config.allowAliases {
        # EOL
        sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
        sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
        sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
        sdk_3_1 = throw "Dotnet SDK 3.1 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
        sdk_5_0 = throw "Dotnet SDK 5.0 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
      }
      // lib.mergeAttrsList [
        dotnet_6
        dotnet_7
        dotnet_8
        dotnet_9
        dotnet_10
        dotnet_11
      ]
    );
in
pkgs
