{ cabal, aeson, blazeBuilder, blazeHtml, Cabal, caseInsensitive
, cereal, clientsession, conduit, cookie, failure, fastLogger
, hamlet, httpTypes, liftedBase, monadControl, parsec, pathPieces
, random, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.10.1";
  sha256 = "011bxz0wjd349jhwxh0cs1lhqpjgwq57ia8wzxf21bcwy8c08nj0";
  buildDepends = [
    aeson blazeBuilder blazeHtml Cabal caseInsensitive cereal
    clientsession conduit cookie failure fastLogger hamlet httpTypes
    liftedBase monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra waiLogger yesodRoutes
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
