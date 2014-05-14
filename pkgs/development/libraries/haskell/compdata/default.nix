{ cabal, deepseq, derive, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, thExpandSyns
, transformers
}:

cabal.mkDerivation (self: {
  pname = "compdata";
  version = "0.7.0.1";
  sha256 = "0d511yjfydv43sr74ggz6pnqm0wqz2m9fgrxpl6avvj8p10va7h7";
  buildDepends = [
    deepseq derive mtl QuickCheck thExpandSyns transformers
  ];
  testDepends = [
    deepseq derive HUnit mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 thExpandSyns
    transformers
  ];
  meta = {
    description = "Compositional Data Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
