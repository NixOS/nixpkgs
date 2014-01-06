{ cabal, baseUnicodeSymbols, concurrentExtra, HUnit, stm
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "threads";
  version = "0.5.1.0";
  sha256 = "077gcnzpy7bjx1rkyl9nriywfiisx0vhmdapl94fl01ira7cm700";
  buildDepends = [ baseUnicodeSymbols stm ];
  testDepends = [
    baseUnicodeSymbols concurrentExtra HUnit stm testFramework
    testFrameworkHunit
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/basvandijk/threads";
    description = "Fork threads and wait for their result";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
