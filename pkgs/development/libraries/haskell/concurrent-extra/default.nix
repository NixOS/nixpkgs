{ cabal, async, baseUnicodeSymbols, HUnit, random, stm
, testFramework, testFrameworkHunit, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "concurrent-extra";
  version = "0.7.0.8";
  sha256 = "0q6n7wlakvnvfrjr3zmxbn9i0dxq96071j565vffp0r5abxkn83q";
  buildDepends = [ baseUnicodeSymbols stm unboundedDelays ];
  testDepends = [
    async baseUnicodeSymbols HUnit random stm testFramework
    testFrameworkHunit unboundedDelays
  ];
  meta = {
    homepage = "https://github.com/basvandijk/concurrent-extra";
    description = "Extra concurrency primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
