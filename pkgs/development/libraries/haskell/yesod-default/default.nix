{ cabal, Cabal, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, waiExtra, warp, yaml, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "0.6.1";
  sha256 = "0am5f8r2w7695zfc6vi0gy8yin9kfgj37qzr14r5v6wzhk1gq5da";
  buildDepends = [
    Cabal shakespeareCss shakespeareJs text transformers
    unorderedContainers wai waiExtra warp yaml yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Default config and main functions for your yesod application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
