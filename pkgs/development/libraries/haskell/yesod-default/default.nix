{ cabal, networkConduit, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.0.0";
  sha256 = "1l6x56ky3jf20nvz03jsxs19dvh1rz108gzhgbh86qjhcisaaqvi";
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
