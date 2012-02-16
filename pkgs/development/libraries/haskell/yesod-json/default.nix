{ cabal, aeson, attoparsecConduit, blazeBuilder, Cabal, conduit
, safe, shakespeareJs, text, transformers, vector, wai, waiExtra
, yesodCore, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.3.1";
  sha256 = "17w82mfl364dc0k1zk1gqas3fyskz2jc50diq71fiw87apslva4v";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder Cabal conduit safe
    shakespeareJs text transformers vector wai waiExtra yesodCore
    yesodRoutes
  ];
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
