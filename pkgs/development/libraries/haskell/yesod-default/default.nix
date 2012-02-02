{ cabal, cmdargs, dataObject, dataObjectYaml, shakespeareCss
, shakespeareJs, text, transformers, wai, waiExtra, warp, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "0.5.0";
  sha256 = "02j9567nmyxr68q8p8ihbig9b6f9p9ciif8nlp03mfkbq10hwrm3";
  buildDepends = [
    cmdargs dataObject dataObjectYaml shakespeareCss shakespeareJs text
    transformers wai waiExtra warp yesodCore
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
