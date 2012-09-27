{ cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource
, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.3.1";
  sha256 = "06b4v7012fj1kmnz6i63vbwl9gkhzgk556gmcc62k14299ks8pci";
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
