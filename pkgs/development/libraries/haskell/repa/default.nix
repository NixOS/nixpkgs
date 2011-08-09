{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "2.1.1.3";
  sha256 = "1qnms2ivy1bq8lv150v0dvlsc05hlbfm3rwwsmqyfagy1bziqbma";
  buildDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
