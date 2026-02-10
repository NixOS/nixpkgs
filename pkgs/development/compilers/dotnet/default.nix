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
            ./versions/10.0.nix
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

        generate-dotnet-sdk = writeScriptBin "generate-dotnet-sdk" (
          # Don't include current nixpkgs in the exposed version. We want to make the script runnable without nixpkgs repo.
          builtins.replaceStrings [ " -I nixpkgs=./." ] [ "" ] (builtins.readFile ./update.sh)
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

        dotnet_8 = lib.recurseIntoAttrs (callPackage ./8 { });
        dotnet_9 = lib.recurseIntoAttrs (callPackage ./9 { });
        dotnet_10 = lib.recurseIntoAttrs (callPackage ./10 { });
      }
    );
  };

  # combine an SDK with the runtime/packages from a base SDK
  combineSdk =
    base: fallback:
    if (fallback.runtime.version != base.runtime.version) then
      throw "combineSdk: unable to combine ${fallback.name} with ${base.name} because runtime versions don't match (${fallback.runtime.version} != ${base.runtime.version})"
    else if base.meta.broken then
      fallback
    else
      let
        withBaseRuntimes =
          if fallback.version == base.version then
            base.unwrapped
          else
            (pkgs.combinePackages [
              base.runtime
              base.aspnetcore
              fallback
            ]).unwrapped.overrideAttrs
              (old: {
                name = fallback.unwrapped.name;
                # resolve symlinks so DOTNET_ROOT is self-contained
                postBuild = ''
                  mv "$out"/share/dotnet{,~}
                  cp -Lr "$out"/share/dotnet{~,}
                  rm -r "$out"/share/dotnet~
                ''
                + old.postBuild;
                passthru = old.passthru // {
                  inherit (base)
                    runtime
                    aspnetcore
                    ;
                  inherit (fallback.unwrapped)
                    pname
                    version
                    ;
                };
              });

        withFallbackPackages = withBaseRuntimes.overrideAttrs (old: {
          passthru =
            old.passthru
            // (
              let
                hostRid = pkgs.systemToDotnetRid base.stdenv.hostPlatform.system;
                hasILCompiler = base.hasILCompiler || fallback.hasILCompiler;
                packageName = "runtime.${hostRid}.Microsoft.DotNet.ILCompiler";
                mergePackages =
                  a: b:
                  let
                    names = lib.genAttrs' a (p: lib.nameValuePair p.pname null);
                  in
                  a ++ lib.filter (p: !lib.hasAttr p.pname names) b;
                packages = mergePackages base.packages fallback.packages;
                targetPackages = lib.mapAttrs (
                  name: value: mergePackages value fallback.targetPackages.${name}
                ) base.targetPackages;
              in
              {
                inherit hasILCompiler packages targetPackages;
              }
            );
        });
      in
      pkgs.callPackage ./wrapper.nix { } "sdk" withFallbackPackages;

in
pkgs
// rec {
  # use binary SDK here to avoid downgrading feature band
  sdk_8_0_1xx = combineSdk pkgs.dotnet_8.sdk pkgs.sdk_8_0_1xx-bin;
  sdk_9_0_1xx = combineSdk pkgs.dotnet_9.sdk pkgs.sdk_9_0_1xx-bin;
  sdk_10_0_1xx = combineSdk pkgs.dotnet_10.sdk pkgs.sdk_10_0_1xx-bin;
  # source-built SDK only exists for _1xx feature band
  # https://github.com/dotnet/source-build/issues/3667
  sdk_8_0_4xx = combineSdk sdk_8_0_1xx pkgs.sdk_8_0_4xx-bin;
  sdk_9_0_3xx = combineSdk sdk_9_0_1xx pkgs.sdk_9_0_3xx-bin;
  sdk_8_0 = sdk_8_0_4xx;
  sdk_9_0 = sdk_9_0_3xx;
  sdk_10_0 = sdk_10_0_1xx;
  sdk_8_0-source = if !pkgs.dotnet_8.vmr.meta.broken then pkgs.dotnet_8.sdk else pkgs.sdk_8_0_1xx-bin;
  sdk_9_0-source = if !pkgs.dotnet_9.vmr.meta.broken then pkgs.dotnet_9.sdk else pkgs.sdk_9_0_1xx-bin;
  sdk_10_0-source =
    if !pkgs.dotnet_10.vmr.meta.broken then pkgs.dotnet_10.sdk else pkgs.sdk_10_0_1xx-bin;
  runtime_8_0 = sdk_8_0.runtime;
  runtime_9_0 = sdk_9_0.runtime;
  runtime_10_0 = sdk_10_0.runtime;
  aspnetcore_8_0 = sdk_8_0.aspnetcore;
  aspnetcore_9_0 = sdk_9_0.aspnetcore;
  aspnetcore_10_0 = sdk_10_0.aspnetcore;
}
