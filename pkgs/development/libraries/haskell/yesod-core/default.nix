{ cabal, aesonNative, blazeBuilder, blazeHtml, caseInsensitive
, cereal, clientsession, cookie, dataObject, dataObjectYaml
, enumerator, failure, hamlet, httpTypes, monadControl, parsec
, pathPieces, random, shakespeare, shakespeareCss, shakespeareJs
, strictConcurrency, text, time, transformers, vector, wai
, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.3.2";
  sha256 = "1h45vgxcn4sraax5rsccksx5yz57k32d7vzpp02prz2s2x5bv3xl";
  buildDepends = [
    aesonNative blazeBuilder blazeHtml caseInsensitive cereal
    clientsession cookie dataObject dataObjectYaml enumerator failure
    hamlet httpTypes monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareJs strictConcurrency text time
    transformers vector wai waiExtra
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
