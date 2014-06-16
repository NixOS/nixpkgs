{ cabal, deepseq, derive, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, thExpandSyns
, transformers, treeView
}:

cabal.mkDerivation (self: {
  pname = "compdata";
  version = "0.8.1.2";
  sha256 = "1jhfhinkn6klh68rzl5skh1rianjycc6cfkrglsi17j60a723v9x";
  buildDepends = [
    deepseq derive mtl QuickCheck thExpandSyns transformers treeView
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
