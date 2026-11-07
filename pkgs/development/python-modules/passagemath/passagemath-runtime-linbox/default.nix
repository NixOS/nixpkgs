{
  callPackage,
  lib,
  linbox,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-linbox";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev linbox}/lib/pkgconfig"
    ];
  };
}
