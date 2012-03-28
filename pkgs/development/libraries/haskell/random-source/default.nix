{ cabal, flexibleDefaults, mersenneRandomPure64, mtl, mwcRandom
, random, stateref, syb, thExtras
}:

cabal.mkDerivation (self: {
  pname = "random-source";
  version = "0.3.0.2";
  sha256 = "0sp39bj7rqg4w4rc4d4zgj0f77c23z4xc47p55chy12znc4frlp2";
  buildDepends = [
    flexibleDefaults mersenneRandomPure64 mtl mwcRandom random stateref
    syb thExtras
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Generic basis for random number generators";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
