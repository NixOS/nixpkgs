{
  givaro,
  lib,
  mkSageRuntimeConfig,
}:

mkSageRuntimeConfig {
  pname = "passagemath-runtime-givaro";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev givaro}/lib/pkgconfig"
    ];
  };
}

