{
  lib,
  linbox,
  mkSageRuntimeConfig,
}:

mkSageRuntimeConfig {
  pname = "passagemath-runtime-linbox";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev linbox}/lib/pkgconfig"
    ];
  };
}
