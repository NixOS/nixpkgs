/*
  How to combine packages for use in development:
  dotnetCombined = with dotnetCorePackages; combinePackages [ sdk_9_0 aspnetcore_8_0 ];

  Hashes and urls are retrieved from:
  https://dotnet.microsoft.com/download/dotnet
*/
{
  lib,
  config,
  recurseIntoAttrs,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:

let
  pkgs = makeScopeWithSplicing' {
    otherSplices = generateSplicesForMkScope "dotnetCorePackages";
    f = (
      self:
      let
        callPackage = self.callPackage;

        fetchNupkg = callPackage ../../../build-support/dotnet/fetch-nupkg { };

        buildDotnet = attrs: callPackage (import ./build-dotnet.nix attrs) { };
        buildDotnetSdk =
          version:
          import version {
            inherit fetchNupkg;
            buildAspNetCore = attrs: buildDotnet (attrs // { type = "aspnetcore"; });
            buildNetRuntime = attrs: buildDotnet (attrs // { type = "runtime"; });
            buildNetSdk = attrs: buildDotnet (attrs // { type = "sdk"; });
          };

        ## Files in versions/ are generated automatically by update.sh ##
        dotnet-bin = lib.mergeAttrsList (
          map buildDotnetSdk [
            ./versions/6.0.nix
            ./versions/7.0.nix
            ./versions/8.0.nix
            ./versions/9.0.nix
          ]
        );

        runtimeIdentifierMap = {
          "x86_64-linux" = "linux-x64";
          "aarch64-linux" = "linux-arm64";
          "x86_64-darwin" = "osx-x64";
          "aarch64-darwin" = "osx-arm64";
          "x86_64-windows" = "win-x64";
          "i686-windows" = "win-x86";
        };

      in
      lib.optionalAttrs config.allowAliases (
        {
          # EOL
          sdk_2_1 = throw "Dotnet SDK 2.1 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
          sdk_2_2 = throw "Dotnet SDK 2.2 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
          sdk_3_0 = throw "Dotnet SDK 3.0 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
          sdk_3_1 = throw "Dotnet SDK 3.1 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
          sdk_5_0 = throw "Dotnet SDK 5.0 is EOL, please use 8.0 (LTS) or 9.0 (Current)";
        }
        // dotnet-bin
      )
      // lib.mapAttrs' (k: v: lib.nameValuePair "${k}-bin" v) dotnet-bin
      // {
        inherit callPackage fetchNupkg buildDotnetSdk;

        # Convert a "stdenv.hostPlatform.system" to a dotnet RID
        systemToDotnetRid =
          system: runtimeIdentifierMap.${system} or (throw "unsupported platform ${system}");

        combinePackages = attrs: callPackage (import ./combine-packages.nix attrs) { };

        patchNupkgs = callPackage ./patch-nupkgs.nix { };
        nugetPackageHook = callPackage ./nuget-package-hook.nix { };

        buildDotnetModule = callPackage ../../../build-support/dotnet/build-dotnet-module { };
        buildDotnetGlobalTool = callPackage ../../../build-support/dotnet/build-dotnet-global-tool { };

        mkNugetSource = callPackage ../../../build-support/dotnet/make-nuget-source { };
        mkNugetDeps = callPackage ../../../build-support/dotnet/make-nuget-deps { };
        addNuGetDeps = callPackage ../../../build-support/dotnet/add-nuget-deps { };

        dotnet_8 = recurseIntoAttrs (callPackage ./8 { });
        dotnet_9 = recurseIntoAttrs (callPackage ./9 { });
      }
    );
  };
in
pkgs
// rec {
  # use binary SDK here to avoid downgrading feature band
  sdk_8_0_1xx = if !pkgs.dotnet_8.vmr.meta.broken then pkgs.dotnet_8.sdk else pkgs.sdk_8_0_1xx-bin;
  # source-built SDK only exists for _1xx feature band
  sdk_8_0_4xx = pkgs.callPackage ./wrapper.nix { } "sdk" (
    pkgs.sdk_8_0_4xx-bin.unwrapped.overrideAttrs (old: {
      passthru =
        old.passthru
        // {
          inherit (sdk_8_0_1xx)
            runtime
            aspnetcore
            ;
        }
        # We can't use the source-built packages until ilcompiler is fixed (see vmr.nix)
        // lib.optionalAttrs sdk_8_0_1xx.hasILCompiler {
          inherit (sdk_8_0_1xx)
            packages
            targetPackages
            ;
        };
    })
  );
  sdk_8_0 = sdk_8_0_4xx;
  sdk_8_0-source = sdk_8_0_1xx;
  runtime_8_0 = sdk_8_0.runtime;
  aspnetcore_8_0 = sdk_8_0.aspnetcore;
}
// rec {
  sdk_9_0_1xx = if !pkgs.dotnet_9.vmr.meta.broken then pkgs.dotnet_9.sdk else pkgs.sdk_9_0_1xx-bin;
  sdk_9_0 = sdk_9_0_1xx;
  runtime_9_0 = sdk_9_0.runtime;
  aspnetcore_9_0 = sdk_9_0.aspnetcore;
}
