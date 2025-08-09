{ lib, config, ... }:
let
  inherit (lib) options types;
  Package = import ./package.nix { inherit lib config; };
in
options.mkOption {
  description = "Release is an attribute set which includes a mapping from platform to package";
  example = (import ./manifest.nix { inherit lib; }).cuda_cccl;
  type = types.attrsOf Package.type;
}
