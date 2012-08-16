{ cabal, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.1.0";
  sha256 = "0r0a3s1dngqp2vcq0cdsbqf1lsyhygj2x4a93csr2iyn244zgxnx";
  buildDepends = [ pathPieces text vector ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Efficient routing for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
