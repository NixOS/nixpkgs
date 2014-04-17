{ cabal, mmorph, mtl, QuickCheck, testFramework
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.1.1";
  sha256 = "1ib7vs4x8ckajlg3nz9lx2snnwj75by90fbv4znwhwgrhj4h13dn";
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
