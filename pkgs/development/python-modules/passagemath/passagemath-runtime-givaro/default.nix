{
  callPackage,
  givaro,
  lib,
}:

let
  mkSageRuntimeConfig = callPackage ../mk-sage-runtime-config.nix { };
in
mkSageRuntimeConfig {
  pname = "passagemath-runtime-givaro";

  sageConf = {
    PKG_CONFIG_PATHS = [
      "${lib.getDev givaro}/lib/pkgconfig"
    ];
  };

  meta = {
    description = "Runtime configuration for PassageMath with Givaro";
    longDescription = ''
      Provides the Nix store paths for Givaro through `sage.config`,
      allowing PassageMath to discover its runtime dependencies.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
