{ cabal, hspec, parsec, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.2.0.2";
  sha256 = "1vp7zskxrjxcznj1d0nx9iqkfvwa9xwpbxq46z054bizqfkri96c";
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
