{ cabal, doctest, either, filepath, QuickCheck, transformers }:

cabal.mkDerivation (self: {
  pname = "quickcheck-property-monad";
  version = "0.2.2";
  sha256 = "1liixl4xxpx9f3877sss16m67y5bkwhxdmr8h40rpqdi7dz9s0mj";
  buildDepends = [ either QuickCheck transformers ];
  testDepends = [ doctest filepath QuickCheck ];
  meta = {
    homepage = "http://github.com/bennofs/quickcheck-property-monad/";
    description = "quickcheck-property-monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
