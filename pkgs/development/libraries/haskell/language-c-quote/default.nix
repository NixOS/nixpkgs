{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, mainlandPretty, mtl, srcloc, syb, symbol
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.4.1";
  sha256 = "1graq6nfmzd2lj6fh1rwyaikfrlzn05pgd347dzrfq5ch35fgg10";
  buildDepends = [
    exceptionMtl exceptionTransformers filepath haskellSrcMeta
    mainlandPretty mtl srcloc syb symbol
  ];
  buildTools = [ alex happy ];
  jailbreak = true;
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "C/CUDA/OpenCL quasiquoting library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
