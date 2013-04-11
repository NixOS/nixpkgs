{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "utility-ht";
  version = "0.0.9";
  sha256 = "1m5mjxwf51jd00swp1f4cimaqaral6827y1sidbq61qkw7l6ss8r";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Various small helper functions for Lists, Maybes, Tuples, Functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
