{
  lib,
  yarn-berry,
  yarn,
  replaceVars,
  libzip,
  zlib,
  zlib-ng,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  fetchpatch,
}:

let
  variantOverlays = {
    "3" = final: {
      berryCacheVersion = "8";

      berryOfflinePatches = [
        (replaceVars ./berry-3-offline.patch {
          yarnv1 = lib.getExe yarn;
        })
      ];

      # Known good version: 1.11.3
      libzip =
        (libzip.override {
          # Known good version: 1.3.1
          zlib = zlib;
        }).overrideAttrs
          (old: {
            patches = (old.patches or [ ]) ++ [
              (final.yarn-berry-fetcher.src + "/libzip-revert-to-old-versionneeded-behavior.patch")
            ];
          });
    };
    "4" = final: {
      berryCacheVersion = "10";

      berryOfflinePatches = [
        (replaceVars ./berry-4-offline.patch {
          yarnv1 = lib.getExe yarn;
        })
      ];

      # Known good version: 1.11.3
      libzip =
        (libzip.override {
          # Known good version: 2.2.4
          zlib =
            (zlib-ng.overrideAttrs (old: {
              patches = old.patches or [ ] ++ [
                # Yarn hashes the output of libzip(untar(tarball)), so the output of libzip
                # needs to be an exact match across versions, and this commit changes the
                # exact output. This is ridiculous, but such is life.
                (fetchpatch {
                  url = "https://github.com/zlib-ng/zlib-ng/commit/be819413be8a284b1827437006c0859644d0c367.patch";
                  revert = true;
                  hash = "sha256-rwRcNKpA2dMWkC6WRATDOCYCDDqqPvFJkQ6DLDohQd8=";
                })
              ];
            })).override
              {
                withZlibCompat = true;
              };
        }).overrideAttrs
          (old: {
            patches = (old.patches or [ ]) ++ [
              ./libzip-revert-to-old-versionneeded-behavior.patch
            ];
          });
    };
  };

  berryVersion = lib.versions.major yarn-berry.version;

  otherSplices = generateSplicesForMkScope "yarn-berry_${berryVersion}-fetcher";
in

makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    final:
    let
      err = throw ''
        Berry version ${toString berryVersion} not supported by yarn-berry-fetcher.
        Supported versions: ${lib.concatStringsSep ", " (lib.attrNames variantOverlays)}
      '';
      variantOverlay = (variantOverlays.${berryVersion} or err) final;
    in
    (
      {
        inherit yarn-berry berryVersion;

        yarn-berry-offline = final.yarn-berry.overrideAttrs (old: {
          pname = old.pname + "-offline";
          patches = (old.patches or [ ]) ++ final.berryOfflinePatches;
        });

        yarn-berry-fetcher = final.callPackage ./yarn-berry-fetcher.nix { };
        fetchYarnBerryDeps = final.callPackage ./fetch-yarn-berry-deps.nix { };
        yarnBerryConfigHook = final.callPackage ./yarn-berry-config-hook.nix { };
      }
      // variantOverlay
    );
}
