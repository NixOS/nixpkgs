{ cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource
, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.3.0";
  sha256 = "17vn1dz4z00xjpsxjx2dfjnz4qhbn5cbkm2s142kdskiphgxi2f8";
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
