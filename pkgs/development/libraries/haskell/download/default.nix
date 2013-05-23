{ cabal, feed, tagsoup, xml }:

cabal.mkDerivation (self: {
  pname = "download";
  version = "0.3.2";
  sha256 = "0nhbfq8q9ckc5fnlg54l361p2jhkag9cz11v07kj9f1kwkm4d7w3";
  buildDepends = [ feed tagsoup xml ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/download";
    description = "High-level file download based on URLs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
