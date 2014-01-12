{ cabal, attoparsec, blazeBuilder, deepseq, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "cassava";
  version = "0.3.0.0";
  sha256 = "0s297664if9zp2y441jihcrmdfgdicjgncyx0rpddlr789vkbs9s";
  buildDepends = [
    attoparsec blazeBuilder deepseq text unorderedContainers vector
  ];
  testDepends = [
    attoparsec HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/tibbe/cassava";
    description = "A CSV parsing and encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
