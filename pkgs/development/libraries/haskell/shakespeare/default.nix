{ cabal, hspec, parsec, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.2.0.4";
  sha256 = "0pgh4sxy5plhmm55mqbcmicn28vlplk4pasgfnyy5wjaz28n6z97";
  buildDepends = [ parsec systemFileio systemFilepath text time ];
  testDepends = [
    hspec parsec systemFileio systemFilepath text time
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
