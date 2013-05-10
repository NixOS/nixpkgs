{ cabal, flexibleDefaults, mersenneRandomPure64, mtl, mwcRandom
, random, stateref, syb, thExtras
}:

cabal.mkDerivation (self: {
  pname = "random-source";
  version = "0.3.0.4";
  sha256 = "1gvx9r6vy36lx7fy537zdbnbhpmfxz88a7gh0aiyd2vi7bvnndxy";
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
