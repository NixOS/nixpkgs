{ lib, ... }:
let
  inherit (lib) options trivial types;
  Release = import ./release.nix { inherit lib; };
in
options.mkOption {
  description = "A redistributable manifest is an attribute set which includes a mapping from package name to release";
  example = trivial.importJSON ../../../../cuda/manifests/redistrib_11.5.2.json;
  type = types.submodule {
    # Allow any attribute name as these will be the package names
    freeformType = types.attrsOf Release.type;
    options = {
      release_date = options.mkOption {
        description = "The release date of the manifest";
        type = types.nullOr types.str;
        default = null;
        example = "2023-08-29";
      };
      release_label = options.mkOption {
        description = "The release label of the manifest";
        type = types.nullOr types.str;
        default = null;
        example = "12.2.2";
      };
      release_product = options.mkOption {
        example = "cuda";
        description = "The release product of the manifest";
        type = types.nullOr types.str;
        default = null;
      };
    };
  };
}
