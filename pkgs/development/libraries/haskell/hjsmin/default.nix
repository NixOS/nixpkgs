{ cabal, blazeBuilder, Cabal, HUnit, languageJavascript
, optparseApplicative, QuickCheck, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.6";
  sha256 = "0z0wzgwm66ckq9h756s7srfyiv2jia9779yi86cn1zgzr8dwspvr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder languageJavascript optparseApplicative text
  ];
  testDepends = [
    blazeBuilder Cabal HUnit languageJavascript QuickCheck
    testFramework testFrameworkHunit text
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
