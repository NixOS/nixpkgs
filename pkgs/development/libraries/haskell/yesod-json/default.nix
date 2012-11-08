{ cabal, aeson, attoparsecConduit, blazeBuilder, conduit, safe
, shakespeareJs, text, transformers, vector, wai, waiExtra
, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "1.1.1";
  sha256 = "1qim3grxbfpq8z3sc9f0zcxwfwaacwiq6hrd2431wvzvbhh6xlbw";
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
