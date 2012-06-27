{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, mainlandPretty, mtl, srcloc, syb, symbol
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.3.1.2";
  sha256 = "0lqr9z2akx90l07k1qbv3y4wwwlcilj08zva4v9scbqydrwpqxip";
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
