{ cabal, dataDefault, hamlet, networkConduit, safe, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.1";
  sha256 = "1nphnb5dvgniff9msj0psa1nbkz3zv2rx221c6xwz9x9gy6n3vwv";
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
