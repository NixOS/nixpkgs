{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, dataObject, dataObjectYaml, enumerator
, failure, fastLogger, hamlet, httpTypes, monadControl, parsec
, pathPieces, random, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiLogger
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.4";
  sha256 = "1m9cxm3pngg4pq7j3p1sh7lrjp5gslnn6zcimc5ln8yldxx01c6g";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    cookie dataObject dataObjectYaml enumerator failure fastLogger
    hamlet httpTypes monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra waiLogger
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
