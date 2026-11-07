{
  fflas-ffpack,
  lib,
  mkSageRuntimeConfig,
}:

mkSageRuntimeConfig {
  pname = "passagemath-runtime-fflas-ffpack";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev fflas-ffpack}/lib/pkgconfig"
    ];
  };
}
