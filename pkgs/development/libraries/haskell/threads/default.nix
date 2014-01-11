{ cabal, baseUnicodeSymbols, concurrentExtra, HUnit, stm
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "threads";
  version = "0.5.1.1";
  sha256 = "196yjkq7wgjcck9wqj4f3x3k47ls9yiay3k6d8k7kzixc2xc621z";
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
