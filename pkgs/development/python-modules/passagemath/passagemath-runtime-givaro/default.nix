{
  callPackage,
  givaro,
  lib,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-givaro";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev givaro}/lib/pkgconfig"
    ];
  };
}

