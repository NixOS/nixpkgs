{ cabal, hspec, HUnit, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.2.0.2";
  sha256 = "0mjffsz9rk401a86l10vcjfhvfd8jknzml86jb5kpk6ssvnah0n7";
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
