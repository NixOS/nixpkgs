{ cabal, lazysmallcheck, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "Stream";
  version = "0.4.6";
  sha256 = "0ppjcddm8dxxd260dsnzrdijifg4pa66lm401qj4fiddw0b50wzb";
  buildDepends = [ lazysmallcheck QuickCheck ];
  meta = {
    description = "A library for manipulating infinite lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
