{ cabal, dataDefault, hamlet, networkConduit, safe, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.1.3";
  sha256 = "1g0hb6jl0bp2q50pw2cy3hkbww1l230al08s7vfpqir68n9infiy";
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
