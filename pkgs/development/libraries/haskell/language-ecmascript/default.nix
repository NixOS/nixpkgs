{ cabal, dataDefaultClass, Diff, filepath, HUnit, mtl, parsec
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testingFeat, uniplate, wlPprint
}:

cabal.mkDerivation (self: {
  pname = "language-ecmascript";
  version = "0.16";
  sha256 = "1gz0089llxfmq9v2j5hp85h7w2vw50sgbl6dcd7i0s8m5zd3dmqg";
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
