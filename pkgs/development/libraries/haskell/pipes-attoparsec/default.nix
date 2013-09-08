{ cabal, attoparsec, HUnit, mmorph, pipes, pipesParse, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-attoparsec";
  version = "0.3.0";
  sha256 = "1jsgssfs0ndn8aayc0rxyb4vlp2fny8npmnvym7v1yhp2qv84c7b";
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
