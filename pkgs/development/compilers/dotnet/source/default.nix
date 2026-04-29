{
  config,
  stdenvNoCC,
  callPackage,
  lib,
  fetchurl,
  channel,
  featureBand ? "1xx",
  dir ? ../. + ("/" + channel),
  releaseManifestFile ? dir + "/release.json",
  releaseInfoFile ? dir + "/release-info.json",
  bootstrapSdkFile ? dir + "/bootstrap-sdk.nix",
  bootstrapSdk ? null,
  depsFile ? dir + "/deps.json",
  pkgsBuildHost,
  buildDotnetSdk,
  withBinary ? true,
  combinePackages,
  systemToDotnetRid,
  binary,
}@attrs:

assert bootstrapSdk != null || bootstrapSdkFile != null;

let
  suffix =
    let
      parts = lib.splitVersion channel;
      major = lib.elemAt parts 0;
      sdk = lib.concatStringsSep "_" (parts ++ [ featureBand ]);
    in
    {
      source = if featureBand == "1xx" then major else sdk;
      channel = lib.concatStringsSep "_" (lib.take 2 parts);
      inherit major sdk;
    };

  releaseInfo = (lib.importJSON releaseInfoFile);
  inherit (releaseInfo)
    tarballHash
    artifactsUrl
    artifactsHash
    ;

  artifacts = stdenvNoCC.mkDerivation {
    name = lib.nameFromURL artifactsUrl ".tar.gz";

    src = fetchurl {
      url = artifactsUrl;
      hash = artifactsHash;
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

  vmr =
    if bootstrapSdk != null then
      callPackage ./vmr.nix {
        inherit
          releaseManifestFile
          tarballHash
          ;
        bootstrapSdk = bootstrapSdk.unwrapped;
        hasRuntime = false;
      }
    else
      callPackage ./stage1.nix {
        inherit
          releaseManifestFile
          tarballHash
          depsFile
          ;
        bootstrapSdk = (buildDotnetSdk bootstrapSdkFile).sdk.unwrapped.overrideAttrs (old: {
          passthru = old.passthru or { } // {
            inherit artifacts;
          };
        });
      };

  fallbackSdk = binary.${"sdk_${suffix.sdk}"};
  fallbackTargetPackages = fallbackSdk.targetPackages;

  vmrPackages =
    let
      pkgs = callPackage ./packages.nix {
        inherit vmr fallbackTargetPackages;
      };
    in
    lib.recurseIntoAttrs pkgs;

  source =
    vmrPackages
    // lib.optionalAttrs vmr.meta.broken rec {
      sdk = fallbackSdk;
      inherit (sdk) runtime aspnetcore;
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
            (combinePackages [
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
                    hasILCompiler
                    ;
                };
              });

        withFallbackPackages = withBaseRuntimes.overrideAttrs (old: {
          passthru =
            old.passthru
            // (
              let
                hasILCompiler = base.hasILCompiler || withBaseRuntimes.hasILCompiler;
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
      callPackage ../wrapper.nix { } "sdk" withFallbackPackages;
in
{
  "dotnet_${suffix.source}" = vmrPackages;
}
// (
  let
    combined = lib.mapAttrs (s: v: combineSdk source.sdk v) (
      if withBinary then
        lib.filterAttrs (n: _: lib.substring 0 4 n == "sdk_") binary
      else
        {
          "sdk_${suffix.sdk}" = binary.${"sdk_${suffix.sdk}"};
        }
        //
          lib.optionalAttrs (lib.versionAtLeast source.sdk.version binary.${"sdk_${suffix.channel}"}.version)
            {
              "sdk_${suffix.channel}" = binary.${"sdk_${suffix.channel}"};
            }
    );
  in
  combined
  // {
    "sdk_${suffix.channel}-source" = source.sdk;
    "runtime_${suffix.channel}" = source.runtime;
    "aspnetcore_${suffix.channel}" = source.aspnetcore;
  }
)
// lib.optionalAttrs withBinary (
  lib.mergeAttrsList (
    map
      (
        featureBand:
        callPackage ./default.nix (
          attrs
          // {
            inherit featureBand;
            dir = dir + "/${featureBand}";
            withBinary = false;
            bootstrapSdk = vmrPackages.sdk;
          }
        )
      )
      (
        lib.filter (x: x != "1xx") (
          map (x: lib.elemAt x 2) (
            lib.filter (x: x != null && lib.versionAtLeast (lib.elemAt x 0) "10") (
              map (lib.match "sdk_(.*)_(.*)_(.*)") (lib.attrNames binary)
            )
          )
        )
      )
  )
)
