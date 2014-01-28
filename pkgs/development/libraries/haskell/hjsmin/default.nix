{ cabal, blazeBuilder, Cabal, HUnit, languageJavascript
, optparseApplicative, QuickCheck, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.5";
  sha256 = "0lzqs20kyngbjc7wqq347b1caj0hbf29dvdpxghfpjbrgyvyqh74";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder languageJavascript optparseApplicative text
  ];
  testDepends = [
    blazeBuilder Cabal HUnit languageJavascript QuickCheck
    testFramework testFrameworkHunit text
  ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
