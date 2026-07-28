{ lib }:
lib.mapAttrs (
  redistName: _type:
  let
    redistManifestDir = ./. + "/${redistName}";
  in
  lib.concatMapAttrs (
    fileName: _type:
    let
      # Manifests all end in .json and are named "redistrib_<version>.json".
      version = lib.removePrefix "redistrib_" (lib.removeSuffix ".json" fileName);
    in
    # NOTE: We do not require that all files have this pattern, as manifest directories may contain documentation
    # and utility functions we should ignore.
    lib.optionalAttrs (version != fileName) {
      "${version}" = lib.importJSON (redistManifestDir + "/${fileName}");
    }
  ) (builtins.readDir redistManifestDir)
) (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ])
