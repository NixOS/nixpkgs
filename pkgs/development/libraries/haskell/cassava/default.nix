{ cabal, attoparsec, blazeBuilder, deepseq, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "cassava";
  version = "0.2.2.0";
  sha256 = "0jv8lb9z7yf8rddyac0frsw4d1gchrgx8l9rryhl88gs7jss7dh7";
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
