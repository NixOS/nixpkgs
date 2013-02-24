{ cabal, bitsAtomic, HUnit, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "IORefCAS";
  version = "0.2";
  sha256 = "18hyy3jqr9yky5r873816fqnywrwba90sq6zx61i2vkqlfbll1k9";
  buildDepends = [ bitsAtomic ];
  testDepends = [ bitsAtomic HUnit QuickCheck ];
  meta = {
    description = "Atomic compare and swap for IORefs and STRefs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
