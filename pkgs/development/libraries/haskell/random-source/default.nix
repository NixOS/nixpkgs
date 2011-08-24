{ cabal, flexibleDefaults, mersenneRandomPure64, mtl, mwcRandom
, random, stateref, syb
}:

cabal.mkDerivation (self: {
  pname = "random-source";
  version = "0.3";
  sha256 = "08nj7mq8gjj9rv1zmkr2m30z295k5b352103wb1ag1ryw5wyzg1n";
  buildDepends = [
    flexibleDefaults mersenneRandomPure64 mtl mwcRandom random stateref
    syb
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Generic basis for random number generators";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
