{ cabal, dataDefault, hamlet, networkConduit, safe, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.3.1";
  sha256 = "16kxq93q5q6bz47s1rfgswrygyp1g090b8r11n56r8mnr24ix0mi";
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
