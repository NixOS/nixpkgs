{ cabal, HUnit, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "quickcheck-io";
  version = "0.1.0";
  sha256 = "167ds7c7p1lcfsylxhq2sr0jxbviyim1n42dhyr0s0b6hazw8cjs";
  buildDepends = [ HUnit QuickCheck ];
  meta = {
    description = "Use HUnit assertions as QuickCheck properties";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
