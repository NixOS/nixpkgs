{ cabal, blazeBuilder, blazeMarkup, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.7.0.1";
  sha256 = "05z0a6x49f56bazkcdxpdi2a7pyzsiv7qc72grcz9sqjz1d6yagh";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  testDepends = [
    blazeBuilder blazeMarkup HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
