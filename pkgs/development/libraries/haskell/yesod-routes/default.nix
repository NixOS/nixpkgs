{ cabal, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.1.0.2";
  sha256 = "07nrxqkpc5z32c8lk5wz9m6ql703hdhyd86pfk704frvbic02xly";
  buildDepends = [ pathPieces text vector ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
