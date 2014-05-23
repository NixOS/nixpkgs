{ cabal, deepseq, derive, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, thExpandSyns
, transformers, treeView
}:

cabal.mkDerivation (self: {
  pname = "compdata";
  version = "0.8.1.0";
  sha256 = "06bsdhf40b8111k0fmfc53i5kib9n431f07qyj83pq8isgkk33xc";
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
