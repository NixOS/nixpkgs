{
  lib,
  newScope,
  yarn-berry,
  yarn,
  replaceVars,
  libzip,
  zlib,
  zlib-ng,
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
          (oA: {
            patches = (oA.patches or [ ]) ++ [
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
          zlib = zlib-ng.override {
            withZlibCompat = true;
          };
        }).overrideAttrs
          (oA: {
            patches = (oA.patches or [ ]) ++ [
              (final.yarn-berry-fetcher.src + "/libzip-revert-to-old-versionneeded-behavior.patch")
            ];
          });
    };
  };
in

lib.makeScope newScope (
  final:
  let
    berryVersion = lib.versions.major yarn-berry.version;

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
  )
)
