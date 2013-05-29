{ cabal, baseUnicodeSymbols, HUnit, stm, testFramework
, testFrameworkHunit, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "concurrent-extra";
  version = "0.7.0.5";
  sha256 = "0g1ckrwgdyrlp1m352ivplajqzqhw5ymlkb4miiv7c5i9xyyyqnc";
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
