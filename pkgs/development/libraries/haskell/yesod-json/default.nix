{ cabal, aeson, attoparsecConduit, blazeBuilder, conduit, hspec
, safe, shakespeareJs, text, transformers, vector, wai, waiExtra
, waiTest, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.1.2.2";
  sha256 = "1bl4rs3biv2man0n8ijldil32lyswjqk5ykz0nv06qsaaafjpc3g";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder conduit safe shakespeareJs
    text transformers vector wai waiExtra yesodCore yesodRoutes
  ];
  testDepends = [ hspec text waiTest yesodCore ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
