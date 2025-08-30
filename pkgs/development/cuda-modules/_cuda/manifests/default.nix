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
    lib.optionalAttrs (version != fileName) {
      "${version}" = lib.importJSON (redistManifestDir + "/${fileName}");
    }
  ) (builtins.readDir redistManifestDir)
) (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ])
