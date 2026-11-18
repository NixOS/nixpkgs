{
  lib,
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

  meta = {
    description = "Runtime configuration for PassageMath with GAP";
    longDescription = ''
      Provides the Nix store paths for GAP through `sage.config`,
      allowing PassageMath to discover its runtime dependencies.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
