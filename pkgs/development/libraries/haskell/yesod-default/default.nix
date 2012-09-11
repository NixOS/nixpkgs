{ cabal, dataDefault, hamlet, networkConduit, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.0";
  sha256 = "124407a0in474l71jja04ds0xh84ac5i3jv62iswxlcp1y9f52bq";
  buildDepends = [
    dataDefault hamlet networkConduit shakespeareCss shakespeareJs text
    transformers unorderedContainers wai waiExtra warp yaml yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Default config and main functions for your yesod application";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
