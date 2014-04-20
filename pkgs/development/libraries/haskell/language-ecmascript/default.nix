{ cabal, dataDefaultClass, Diff, filepath, HUnit, mtl, parsec
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testingFeat, uniplate, wlPprint
}:

cabal.mkDerivation (self: {
  pname = "language-ecmascript";
  version = "0.16.1";
  sha256 = "0pqb1r60jjmiwk9giaxnrp9a07h4a97kp6g0nznwpdy32x849gx3";
  buildDepends = [
    dataDefaultClass Diff mtl parsec QuickCheck testingFeat uniplate
    wlPprint
  ];
  testDepends = [
    dataDefaultClass Diff filepath HUnit mtl parsec QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2 uniplate
    wlPprint
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
