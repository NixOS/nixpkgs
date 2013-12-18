{ cabal, hspec, HUnit, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.2.0.3";
  sha256 = "0p2640bbsx1lmxd0wq6qwicp6rbh1c54hjb6kiaczj63yahn04y3";
  buildDepends = [ pathPieces text vector ];
  testDepends = [ hspec HUnit pathPieces text ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
