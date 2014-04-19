{ cabal, constraints, dataHash, mtl, QuickCheck, tasty, tastyGolden
, tastyQuickcheck, tastyTh, transformers, treeView, tuple
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "syntactic";
  version = "1.11";
  sha256 = "1j4k4qwi17x9z0cjf9adndaj5wbs8prs36xpz2icf7mlwcr9pvrz";
  buildDepends = [
    constraints dataHash mtl transformers treeView tuple
  ];
  testDepends = [
    mtl QuickCheck tasty tastyGolden tastyQuickcheck tastyTh utf8String
  ];
  meta = {
    homepage = "https://github.com/emilaxelsson/syntactic";
    description = "Generic abstract syntax, and utilities for embedded languages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
