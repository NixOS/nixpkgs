{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  Package = import ./package.nix { inherit lib; };

in
types.submodule (
  { options, ... }:
  {
    freeformType = types.attrsOf (
      if options.cuda_variant.isDefined then types.attrsOf Package else Package
    );
    options = {
      name = mkOption {
        description = "Full name of the package";
        example = "CXX Core Compute Libraries";
        type = types.nullOr types.str;
        default = null;
      };
      license = mkOption {
        description = "License of the package";
        example = "CUDA Toolkit";
        type = types.nullOr types.str;
        default = null;
      };
      license_path = mkOption {
        description = "Path to the license of the package";
        example = "cuda_cccl/LICENSE.txt";
        default = null;
        type = types.nullOr types.str;
      };
      version = mkOption {
        description = "Version of the package";
        example = "11.5.62";
        type = types.str;
      };
      cuda_variant = lib.mkOption {
        type = types.listOf types.str;
        example = [
          "11"
          "12"
        ];
      };
      _recurseForTags = lib.mkOption {
        type = types.bool;
        default = options.cuda_variant.isDefined;
        internal = true;
        readOnly = true;
      };
    };

    # Handled by `freeformType.apply` in `manifest.nix`

    _file = ./release.nix;
  }
)
