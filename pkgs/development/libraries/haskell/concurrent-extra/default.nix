{ cabal, baseUnicodeSymbols, HUnit, stm, testFramework
, testFrameworkHunit, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "concurrent-extra";
  version = "0.7.0.7";
  sha256 = "1736y8am24x29qq1016f2dvb6adavl1h46bsjfwnkw40a9djd5cr";
  buildDepends = [ baseUnicodeSymbols stm unboundedDelays ];
  testDepends = [
    baseUnicodeSymbols HUnit stm testFramework testFrameworkHunit
    unboundedDelays
  ];
  meta = {
    homepage = "https://github.com/basvandijk/concurrent-extra";
    description = "Extra concurrency primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
