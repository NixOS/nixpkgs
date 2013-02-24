{ cabal, blazeBuilder, blazeMarkup, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.6.0.0";
  sha256 = "0n8jpmslcs29pfyb8jhp43dg4058ahd9y3kf2p2wr3r6b9yr5dll";
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
