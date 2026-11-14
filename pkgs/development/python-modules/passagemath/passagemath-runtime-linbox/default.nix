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

  meta = {
    description = "Runtime configuration for PassageMath with LinBox";
    longDescription = ''
      Provides the Nix store paths for LinBox through `sage.config`,
      allowing PassageMath to discover its runtime dependencies.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
