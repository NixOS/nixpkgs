{ cabal, aeson, attoparsecConduit, blazeBuilder, conduit, safe
, shakespeareJs, text, transformers, vector, wai, waiExtra
, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.1.2.1";
  sha256 = "0vrhn3v26q7cqwds99hqyibq09vyxnviqzgyn7w5ldnl3ycg7dqd";
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
