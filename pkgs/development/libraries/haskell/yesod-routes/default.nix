{ cabal, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.0.0";
  sha256 = "1sqlcawsbv8sz22prcg41dvma6kywyl18dwp7msjlbkxgc2msp3a";
  buildDepends = [ pathPieces text vector ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
