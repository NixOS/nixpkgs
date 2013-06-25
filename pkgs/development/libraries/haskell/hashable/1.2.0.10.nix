{ cabal, HUnit, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.2.0.10";
  sha256 = "155r7zqc0kisjdslr8d1c04yqwvzwqx4d99c0zla113dvsdjhp37";
  buildDepends = [ text ];
  testDepends = [
    HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
