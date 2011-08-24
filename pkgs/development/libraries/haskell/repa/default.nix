{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "2.1.1.5";
  sha256 = "14lq6nsifxsap98c1hpxsyv4g973vyzjn2s94b3vfzkbq8vd7695";
  buildDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
