{
  stdenvNoCC,
  callPackage,
  lib,
  fetchurl,
  releaseManifestFile,
  releaseInfoFile,
  bootstrapSdkFile,
  allowPrerelease ? false,
  depsFile,
  pkgsBuildHost,
  buildDotnetSdk,
}:

let
  inherit (lib.importJSON releaseInfoFile)
    tarballHash
    artifactsUrl
    artifactsHash
    bootstrapSdk
    ;

  pkgs = callPackage ./stage1.nix {
    inherit
      releaseManifestFile
      tarballHash
      depsFile
      ;
    bootstrapSdk = (buildDotnetSdk bootstrapSdkFile).sdk.unwrapped.overrideAttrs (old: {
      passthru = old.passthru or { } // {
        artifacts = stdenvNoCC.mkDerivation rec {
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
