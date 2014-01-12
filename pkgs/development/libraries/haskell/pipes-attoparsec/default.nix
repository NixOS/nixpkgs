{ cabal, attoparsec, HUnit, mmorph, pipes, pipesParse, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-attoparsec";
  version = "0.3.1";
  sha256 = "1bvz5fxy2mfz3swiv9jfmhxl1psmm3c7nfi58pggam52lz20va2h";
  buildDepends = [ attoparsec pipes pipesParse text transformers ];
  testDepends = [
    attoparsec HUnit mmorph pipes pipesParse QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-attoparsec";
    description = "Attoparsec and Pipes integration";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
