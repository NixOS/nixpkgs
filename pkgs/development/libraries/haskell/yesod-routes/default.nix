{ cabal, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "0.0.1";
  sha256 = "19bnww5idxr0j2l8g838idxkhhn73bhdz0bnvglinv7163fy8xhl";
  buildDepends = [ pathPieces text vector ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
