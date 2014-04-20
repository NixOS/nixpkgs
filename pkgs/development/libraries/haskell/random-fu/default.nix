{ cabal, erf, mathFunctions, monadLoops, mtl, randomShuffle
, randomSource, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.5.0";
  sha256 = "1yfq7mvplzdk64i7z5ip8vjynn48a65z28xrhcv91qi0yjxsxdm0";
  buildDepends = [
    erf mathFunctions monadLoops mtl randomShuffle randomSource rvar
    syb transformers vector
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random number generation";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
