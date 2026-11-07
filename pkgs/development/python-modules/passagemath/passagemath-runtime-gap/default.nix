{
  mkSageRuntimeConfig,
  gap
}:

mkSageRuntimeConfig {
  pname = "passagemath-runtime-gap";
  sageConf = {
    GAP_ROOT_PATHS = "${gap}/share/gap";
  };
}
