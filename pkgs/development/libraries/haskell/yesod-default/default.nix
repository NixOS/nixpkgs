{ cabal, dataDefault, hamlet, networkConduit, safe, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.2";
  sha256 = "0asz9daf7by0d8sx8zqjsbxbzbyy59bvrdkq4f533fbn0nm1bn38";
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
