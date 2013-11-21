{ cabal, dataDefaultClass, Diff, filepath, HUnit, mtl, parsec
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, uniplate, wlPprint
}:

cabal.mkDerivation (self: {
  pname = "language-ecmascript";
  version = "0.15.3";
  sha256 = "0ircm20nf321awl0gvy0vh3jplfwpd700br67f0i97rifxx2v40c";
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
