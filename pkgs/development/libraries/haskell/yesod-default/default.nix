{ cabal, networkConduit, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.0.1";
  sha256 = "1b9qxfs9pbgn090cipnnbd6vf1ajyhs0xjfynkj87k8fx6j2lqb9";
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
