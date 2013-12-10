{ cabal, blazeBuilder, Cabal, HUnit, languageJavascript, QuickCheck
, testFramework, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.4";
  sha256 = "0hzh2xbv9x013s1lhmgapjd0qx8v7n09rjlfxd9b1h5min00k048";
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
