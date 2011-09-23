{ cabal, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, enumerator, failure, hamlet, httpTypes
, monadControl, parsec, pathPieces, random, shakespeare
, shakespeareCss, shakespeareJs, strictConcurrency, text, time
, transformers, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.2";
  sha256 = "1h9w5fgdr4w4ikp5axzxmsvc14ikbsjmlwd2lmlrh1cjcx8xzjwf";
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
