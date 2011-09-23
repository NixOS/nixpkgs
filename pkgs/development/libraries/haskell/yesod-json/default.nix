{ cabal, aesonNative, shakespeareJs, text, vector, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.2.1";
  sha256 = "1d710pqrdafyz8s0spd19vwvx5v9kwy44wb0byz3445jhi3kwn88";
  buildDepends = [ aesonNative shakespeareJs text vector yesodCore ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
