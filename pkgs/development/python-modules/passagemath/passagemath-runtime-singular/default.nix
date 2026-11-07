{
  lib,
  mkSageRuntimeConfig,
  singular,
}:

mkSageRuntimeConfig {
  pname = "passagemath-runtime-singular";

  sageConf = {
    SINGULAR_BIN = lib.getExe singular;

    PKG_CONFIG_PATHS = [
      "${lib.getDev singular}/lib/pkgconfig"
    ];
  };
}

