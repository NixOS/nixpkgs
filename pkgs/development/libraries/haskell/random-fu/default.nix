{ cabal, erf, mathFunctions, monadLoops, mtl, randomShuffle
, randomSource, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.6.0";
  sha256 = "1mi1hr3hxlnyjf01hgn7xinr1m0rax26759zbkhf5xn04ps0g01p";
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
