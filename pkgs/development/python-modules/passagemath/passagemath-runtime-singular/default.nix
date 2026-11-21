{
  callPackage,
  lib,
  singular,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-singular";

  sageConf = {
    SINGULAR_BIN = lib.getExe singular;

    PKG_CONFIG_PATHS = [
      "${lib.getDev singular}/lib/pkgconfig"
    ];
  };

  meta = {
    description = "Runtime configuration for PassageMath with Singular";
    longDescription = ''
      Provides the Nix store paths for Singular through `sage.config`,
      allowing PassageMath to discover its runtime dependencies.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
