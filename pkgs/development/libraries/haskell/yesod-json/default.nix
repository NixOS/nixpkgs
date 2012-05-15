{ cabal, aeson, attoparsecConduit, blazeBuilder, conduit, safe
, shakespeareJs, text, transformers, vector, wai, waiExtra
, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.0.0.1";
  sha256 = "0dh294y067xa1y9lxamspbq21npv66ilsiayynsiykzik86k6vph";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder conduit safe shakespeareJs
    text transformers vector wai waiExtra yesodCore yesodRoutes
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
