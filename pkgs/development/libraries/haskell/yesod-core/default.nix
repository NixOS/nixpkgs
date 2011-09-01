{ cabal, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, enumerator, failure, hamlet, httpTypes
, monadControl, parsec, pathPieces, random, shakespeare
, shakespeareCss, shakespeareJs, strictConcurrency, text, time
, transformers, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.1.1";
  sha256 = "1cwywjks37i7411m6ab827q5vx1yjgnqn04am0bxzw001vciadm5";
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
