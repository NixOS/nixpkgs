{ cabal, mmorph, mtl, QuickCheck, testFramework
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.1.0";
  sha256 = "1n10plmrjvmkyv502195mkms48y3lfp5gy08lhyhqqr7kn1gzkf0";
  buildDepends = [ mmorph mtl transformers ];
  testDepends = [
    mtl QuickCheck testFramework testFrameworkQuickcheck2 transformers
  ];
  meta = {
    description = "Compositional pipelines";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
