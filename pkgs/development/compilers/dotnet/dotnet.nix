{
  stdenvNoCC,
  callPackage,
  lib,
  fetchurl,
  releaseManifestFile,
  releaseInfoFile,
  bootstrapSdkFile ? null,
  bootstrapSdk ? null,
  allowPrerelease ? false,
  depsFile,
  fallbackTargetPackages,
  pkgsBuildHost,
  buildDotnetSdk,
}:

assert bootstrapSdkFile != null || bootstrapSdk != null;

let
  inherit (lib.importJSON releaseInfoFile)
    tarballHash
    artifactsUrl
    artifactsHash
    ;

  mkPackages = callPackage ./packages.nix;

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
          };
        });
      };

  pkgs = mkPackages {
    inherit vmr fallbackTargetPackages;
  };

in
pkgs
// {
  vmr = pkgs.vmr.overrideAttrs (old: {
    passthru = old.passthru // {
      updateScript = pkgsBuildHost.callPackage ./update.nix {
        inherit
          releaseManifestFile
          releaseInfoFile
          bootstrapSdkFile
          allowPrerelease
          ;
      };
    };
  });
}
