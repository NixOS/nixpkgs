{ cabal, blazeBuilder, Cabal, HUnit, languageJavascript, QuickCheck
, testFramework, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.3";
  sha256 = "1jhpqfvwvzik41i4mi9fr9w1jlrlc1lj2illlbbwg7r3fwr5hnnl";
  buildDepends = [ blazeBuilder languageJavascript text ];
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
