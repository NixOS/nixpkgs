{ lib, ... }:
let
  inherit (lib)
    options
    types
    ;
  Release = import ./release.nix { inherit lib; };
in
{
  keepIndent = {
    # Allow any attribute name as these will be the package names
    freeformType = types.attrsOf Release.type;
    options = {
      release_date = options.mkOption {
        description = "Release date of the manifest";
        type = types.nullOr types.str;
        default = null;
        example = "2023-08-29";
      };
      release_label = options.mkOption {
        description = "Release label of the manifest";
        type = types.nullOr types.str;
        default = null;
        example = "12.2.2";
      };
      release_product = options.mkOption {
        example = "cuda";
        description = "Release product of the manifest";
        type = types.nullOr types.str;
        default = null;
      };
    };
  };
}
.keepIndent
