{ cabal, HUnit, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.0.4";
  sha256 = "19nrzbbbmsvxdhfhh6wc53lbk0xyjvbcwvjw0snym666j1w2b2l5";
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/idontgetoutmuch/largeword";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
