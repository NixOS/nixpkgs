{
  callPackage,
  fflas-ffpack,
  lib,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-fflas-ffpack";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev fflas-ffpack}/lib/pkgconfig"
    ];
  };
}
