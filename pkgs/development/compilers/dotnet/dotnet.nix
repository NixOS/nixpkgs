{ callPackage
, lib
, releaseManifestFile
, releaseInfoFile
, allowPrerelease ? false
, depsFile
, bootstrapSdk
, pkgsBuildHost
}:

let
  inherit (lib.importJSON releaseInfoFile) tarballHash artifactsUrl artifactsHash;

  pkgs = callPackage ./stage1.nix {
    inherit releaseManifestFile tarballHash depsFile;
    bootstrapSdk =
      { stdenvNoCC
      , dotnetCorePackages
      , fetchurl
      }: bootstrapSdk.overrideAttrs (old: {
        passthru = old.passthru or {} // {
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

in pkgs // {
  vmr = pkgs.vmr.overrideAttrs(old: {
    passthru = old.passthru // {
      updateScript = pkgsBuildHost.callPackage ./update.nix {
        inherit releaseManifestFile releaseInfoFile allowPrerelease;
      };
    };
  });
}
