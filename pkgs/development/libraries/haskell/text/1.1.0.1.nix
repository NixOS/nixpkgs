{ cabal, deepseq, HUnit, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "text";
  version = "1.1.0.1";
  sha256 = "1f0zicvflfd17mr2h9s9idhi0215m2y208jbnh4fx1yj6snnvalw";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
