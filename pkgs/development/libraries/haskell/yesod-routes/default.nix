{ cabal, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.1.1";
  sha256 = "0p85dcabc9yi01rnjqpibxq1c8gkzjx7s83w5qy4d0h8xvhn93ic";
  buildDepends = [ pathPieces text vector ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
