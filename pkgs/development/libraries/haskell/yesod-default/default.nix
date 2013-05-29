{ cabal, dataDefault, hamlet, networkConduit, safe, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.3.2";
  sha256 = "07gm9sj4c231wdmfmb7df1s8wvqa6fw7nhcq554h16h2ibv5pcqg";
  buildDepends = [
    dataDefault hamlet networkConduit safe shakespeareCss shakespeareJs
    text transformers unorderedContainers wai waiExtra warp yaml
    yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Default config and main functions for your yesod application";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
