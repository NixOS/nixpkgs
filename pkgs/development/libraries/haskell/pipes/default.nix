{ cabal, mmorph, mtl, QuickCheck, testFramework
, testFrameworkQuickcheck2, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.0.2";
  sha256 = "18hcpklryyq9f6iwycxzi3sd6gyd9h0gy0ckg4rl7rhgy73hzgcz";
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
