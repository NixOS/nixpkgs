{ cabal, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, enumerator, failure, hamlet, httpTypes
, monadControl, parsec, pathPieces, random, shakespeare
, shakespeareCss, shakespeareJs, strictConcurrency, text, time
, transformers, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.1";
  sha256 = "03dbn915g6jkwk9fp5naqv5bq613nlfpc8jd7568cc1l41b95cbf";
  buildDepends = [
    blazeBuilder blazeHtml caseInsensitive cereal clientsession cookie
    enumerator failure hamlet httpTypes monadControl parsec pathPieces
    random shakespeare shakespeareCss shakespeareJs strictConcurrency
    text time transformers wai waiExtra
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
