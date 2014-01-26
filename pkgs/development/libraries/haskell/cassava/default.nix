{ cabal, attoparsec, blazeBuilder, deepseq, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "cassava";
  version = "0.3.0.1";
  sha256 = "1lsbdhdz6hy6lfnhhp36mbjd9m0w8iv50sd9mj0dj9b4izgdav16";
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
