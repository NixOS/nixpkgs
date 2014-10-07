{ cabal, ChasingBottoms, deepseq, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "containers";
  version = "0.5.5.1";
  sha256 = "08xd9v7q5iiy0aywl7kzq5qv8455xkgq2bljx8f5p6ywyxys8z2b";
  buildDepends = [ deepseq ];
  testDepends = [
    ChasingBottoms deepseq HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    description = "Assorted concrete container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})

