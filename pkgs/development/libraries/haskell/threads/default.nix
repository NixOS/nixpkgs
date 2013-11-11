{ cabal, baseUnicodeSymbols, concurrentExtra, HUnit, stm
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "threads";
  version = "0.5.0.3";
  sha256 = "1da5p65qf1w746flqnl7pxd05pdh8psi6psi0zsqqxmiykw4zvrf";
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
