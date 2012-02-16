{ cabal, Cabal, extensibleExceptions, QuickCheck, random
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.2.12";
  sha256 = "08qr2lh1akjy5daxxk1sy59sg94hvv5s5njs9x6lrx648hy7y8iy";
  buildDepends = [
    Cabal extensibleExceptions QuickCheck random testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
