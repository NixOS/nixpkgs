{ cabal, aeson, shakespeareJs, text, vector, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.2.2";
  sha256 = "11n34wg0jjamghd93ild48rzganbwzbqf6shv8lyy1lsm2jl8q0v";
  buildDepends = [ aeson shakespeareJs text vector yesodCore ];
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
