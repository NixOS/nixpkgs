{ cabal, baseUnicodeSymbols, HUnit, stm, testFramework
, testFrameworkHunit, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "concurrent-extra";
  version = "0.7.0.6";
  sha256 = "12wq86hkgy22qydkj4fw6vb7crzv3010c2mkhsph4rdynr0v588i";
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
