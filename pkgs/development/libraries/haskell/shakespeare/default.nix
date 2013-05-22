{ cabal, hspec, parsec, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.5";
  sha256 = "1dc1yg35pxh45fv20fvnlpas0svqi18h6bdalpjaqjb164s114vf";
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
