{ cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource
, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.4.0";
  sha256 = "1wiwh52qfs699mcj3ylwc97pyabczn6dr8j92qczs89g8vvi91wd";
  buildDepends = [
    erf gamma monadLoops mtl randomShuffle randomSource rvar syb
    transformers vector
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random number generation";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
