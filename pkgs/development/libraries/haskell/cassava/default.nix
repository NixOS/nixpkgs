{ cabal, attoparsec, blazeBuilder, deepseq, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "cassava";
  version = "0.4.0.0";
  sha256 = "0w3npv3403n9rl9nmn8ngp04js28bvsb5c4js17sy1gqgsakqdrl";
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
