{ cabal, mmorph, mtl, QuickCheck, testFramework
, testFrameworkQuickcheck2, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.0.1";
  sha256 = "0q2i58w4nlf23di6rjrv543nmj5d5nkz29q9aciw89zx5x5m22h9";
  buildDepends = [ mmorph mtl transformers void ];
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
