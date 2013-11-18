{ cabal, dataDefaultClass, Diff, filepath, HUnit, mtl, parsec
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, uniplate
}:

cabal.mkDerivation (self: {
  pname = "language-ecmascript";
  version = "0.15.2";
  sha256 = "1iszs9f2jryddcz36a6anfyfxpwjhzn49xjqvnd5m6rjdq6y403w";
  buildDepends = [
    dataDefaultClass Diff mtl parsec QuickCheck uniplate
  ];
  testDepends = [
    dataDefaultClass Diff filepath HUnit mtl parsec QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://github.com/jswebtools/language-ecmascript";
    description = "JavaScript parser and pretty-printer library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
