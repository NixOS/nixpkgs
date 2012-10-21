{ cabal, dataDefault, hamlet, networkConduit, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.0.2";
  sha256 = "0gjf819mrg3h50c8qlnh8i3xzq0z8mdz8bbqrpjx1haljcgxrzm3";
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
