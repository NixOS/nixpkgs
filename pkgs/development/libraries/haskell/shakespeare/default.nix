{ cabal, hspec, parsec, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.5.1";
  sha256 = "1qsg23jqv6lzwqk42yapqydx3fn6crkrzim8wr7ds55z6iblxbq6";
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
