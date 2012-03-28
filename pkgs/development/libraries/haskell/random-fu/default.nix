{ cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource
, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.2.0";
  sha256 = "1wv2c6ba3ad80zyj75xfds98q7psgjkmaqk2zm0srmipq06mx92r";
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
