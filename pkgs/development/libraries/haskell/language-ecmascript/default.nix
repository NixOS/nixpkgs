{ cabal, dataDefaultClass, Diff, filepath, HUnit, mtl, parsec
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, uniplate, wlPprint
}:

cabal.mkDerivation (self: {
  pname = "language-ecmascript";
  version = "0.15.4";
  sha256 = "1drivy75lvrwjx7irdbnnqp7y6mbzbm2pbxy7zzc1nfln6g3k9x7";
  buildDepends = [
    dataDefaultClass Diff mtl parsec QuickCheck uniplate wlPprint
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
