{ cabal, networkConduit, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.0.1.1";
  sha256 = "0jv7fxrgh2x93saz0vrba0mzafq3wmq85b3idcsny4d8mgj6ngv0";
  buildDepends = [
    networkConduit shakespeareCss shakespeareJs text transformers
    unorderedContainers wai waiExtra warp yaml yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Default config and main functions for your yesod application";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
