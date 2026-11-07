{
  callPackage,
  gap,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-gap";
  sageConf = {
    GAP_ROOT_PATHS = "${gap}/share/gap";
  };
}
