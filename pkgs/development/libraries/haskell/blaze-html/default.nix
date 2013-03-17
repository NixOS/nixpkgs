{ cabal, blazeBuilder, blazeMarkup, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.6.1.1";
  sha256 = "08zfmkvahmm613r0nrabwl5zv9ragcrhdqsa8jfdrfdkrf6ckbrc";
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
