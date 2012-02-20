{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, conduit, cookie, failure, fastLogger, hamlet
, httpTypes, liftedBase, monadControl, parsec, pathPieces, random
, shakespeare, shakespeareCss, shakespeareI18n, shakespeareJs, text
, time, transformers, transformersBase, vector, wai, waiExtra
, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.10.2";
  sha256 = "0ghfnpav5d0kzzl3vs4932kf0dgys3ad0658xcyf6i5k0izvkzfp";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    conduit cookie failure fastLogger hamlet httpTypes liftedBase
    monadControl parsec pathPieces random shakespeare shakespeareCss
    shakespeareI18n shakespeareJs text time transformers
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
