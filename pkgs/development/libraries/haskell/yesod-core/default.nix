{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, dataObject, dataObjectYaml, enumerator
, failure, hamlet, httpTypes, monadControl, parsec, pathPieces
, random, shakespeare, shakespeareCss, shakespeareJs
, strictConcurrency, text, time, transformers, transformersBase
, vector, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.3.6";
  sha256 = "00h1ylrr5wrid9vn3jhspibprx0175j9rcwdb1hd7ya5gwmzlhjs";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    cookie dataObject dataObjectYaml enumerator failure hamlet
    httpTypes monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareJs strictConcurrency text time
    transformers transformersBase vector wai waiExtra
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
