{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, mainlandPretty, mtl, srcloc, syb, symbol
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.4.0";
  sha256 = "1qbl81c8fw2gz96n8505yxhw1d3zhxq436ikv173x1zz0b4z26g1";
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
