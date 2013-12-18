{ cabal, hspec, HUnit, pathPieces, text, vector }:

cabal.mkDerivation (self: {
  pname = "yesod-routes";
  version = "1.2.0.4";
  sha256 = "1c3fpfvcdx8ijvjxxfjwld5zl6x4xl2587a8gdj2qmsr94f8lgb9";
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
