{ cabal, aeson, attoparsecConduit, blazeBuilder, conduit, safe
, shakespeareJs, text, transformers, vector, wai, waiExtra
, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.1.2";
  sha256 = "0vbjg038vgdwd5a4w7r5261xgvylzzk4gikk4285ns471x8n0vrf";
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
