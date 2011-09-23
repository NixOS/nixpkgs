{ cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource
, rvar, syb, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "random-fu";
  version = "0.2.1.0";
  sha256 = "0jm91xjrlzj25f3giiv2ka5r8bn1ircj56d5lpqixi7c7r9dc804";
  buildDepends = [
    erf gamma monadLoops mtl randomShuffle randomSource rvar syb
    transformers vector
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random number generation";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
