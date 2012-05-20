{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, mainlandPretty, mtl, srcloc, syb, symbol
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.3.1.0";
  sha256 = "0y3zfc43izvalm1lrbk286nmg4s3vgpj5v2j6j2saz3c7l2ly8z6";
  buildDepends = [
    exceptionMtl exceptionTransformers filepath haskellSrcMeta
    mainlandPretty mtl srcloc syb symbol
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "C/CUDA/OpenCL quasiquoting library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
