{ cabal, constraints, dataHash, mtl, QuickCheck, tasty, tastyGolden
, tastyQuickcheck, tastyTh, transformers, treeView, tuple
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "syntactic";
  version = "1.12.1";
  sha256 = "0p68jgfwzr9mvgrcjdj3235109nhpaichm5irj9m29076axrsb94";
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
