{ cabal, constraints, dataHash, mtl, QuickCheck, tasty, tastyGolden
, tastyQuickcheck, tastyTh, transformers, treeView, tuple
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "syntactic";
  version = "1.13";
  sha256 = "1d5mb7ss6xr7rj93mwrdvkxkx1dlmywxx9sxsmqy7l6gaxs6gq8l";
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
