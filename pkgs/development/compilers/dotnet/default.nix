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

makeScopeWithSplicing' {
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
    // rec {
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

      # use binary SDK here to avoid downgrading feature band
      sdk_8_0 = sdk_8_0_4xx;
      sdk_8_0-source = dotnet_8.sdk;
      sdk_8_0_1xx = dotnet_8.sdk;
      # source-built SDK only exists for _1xx feature band
      sdk_8_0_4xx = callPackage ./wrapper.nix { } "sdk" (
        dotnet-bin.sdk_8_0_4xx.unwrapped.overrideAttrs (old: {
          passthru =
            old.passthru
            // {
              inherit (dotnet_8.sdk)
                runtime
                aspnetcore
                ;
            }
            # We can't use the source-built packages until ilcompiler is fixed (see vmr.nix)
            // lib.optionalAttrs dotnet_8.sdk.hasILCompiler {
              inherit (dotnet_8.sdk)
                packages
                targetPackages
                ;
            };
        })
      );
      runtime_8_0 = dotnet_8.runtime;
      aspnetcore_8_0 = dotnet_8.aspnetcore;

      sdk_9_0 = dotnet_9.sdk;
      sdk_9_0_1xx = dotnet_9.sdk;
      runtime_9_0 = dotnet_9.runtime;
      aspnetcore_9_0 = dotnet_9.aspnetcore;
    }
  );
}
