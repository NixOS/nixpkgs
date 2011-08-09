{ cabal, aeson, blazeTextual, hamlet, text, vector, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.1.1.2";
  sha256 = "0d6dkhzjpxp3687x914h67swm4lgsalb1xr13gz53ddb0qj18n7j";
  buildDepends = [ aeson blazeTextual hamlet text vector yesodCore ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
