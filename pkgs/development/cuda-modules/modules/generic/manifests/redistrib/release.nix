{ lib, ... }:
let
  inherit (lib) options types;
  Package = import ./package.nix { inherit lib; };
in
options.mkOption {
  description = "Release is an attribute set which includes a mapping from platform to package";
  example = (import ./manifest.nix { inherit lib; }).cuda_cccl;
  type = types.submodule {
    # Allow any attribute name as these will be the platform names
    freeformType = types.attrsOf Package.type;
    options = {
      name = options.mkOption {
        description = "Full name of the package";
        example = "CXX Core Compute Libraries";
        type = types.str;
      };
      license = options.mkOption {
        description = "License of the package";
        example = "CUDA Toolkit";
        type = types.str;
      };
      license_path = options.mkOption {
        description = "Path to the license of the package";
        example = "cuda_cccl/LICENSE.txt";
        default = null;
        type = types.nullOr types.str;
      };
      version = options.mkOption {
        description = "Version of the package";
        example = "11.5.62";
        type = types.str;
      };
    };
  };
}
