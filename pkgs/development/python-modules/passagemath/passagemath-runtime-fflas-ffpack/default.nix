{
  callPackage,
  fflas-ffpack,
  lib,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-fflas-ffpack";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev fflas-ffpack}/lib/pkgconfig"
    ];
  };

  meta = {
    description = "Runtime configuration for PassageMath with FFLAS-FFPACK";
    longDescription = ''
      Provides the Nix store paths for FFLAS-FFPACK through `sage.config`,
      allowing PassageMath to discover its runtime dependencies.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
