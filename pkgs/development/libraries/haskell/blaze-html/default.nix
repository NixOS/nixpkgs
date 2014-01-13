{ cabal, blazeBuilder, blazeMarkup, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.6.1.3";
  sha256 = "0hjyi3iv2770wicgfjipa901vk7mwr8kknfqvj3v9kzcvb4lq5aq";
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
