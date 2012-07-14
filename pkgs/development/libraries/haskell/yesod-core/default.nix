{ cabal, aeson, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cereal, clientsession, conduit, cookie, failure
, fastLogger, hamlet, httpTypes, liftedBase, monadControl, parsec
, pathPieces, random, resourcet, shakespeare, shakespeareCss
, shakespeareI18n, shakespeareJs, text, time, transformers
, transformersBase, vector, wai, waiExtra, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.0.1.3";
  sha256 = "1rdj622zi12v9d7cxkn8w4q43k8c6gfz8wrpmvya76gqmg6h2gil";
  buildDepends = [
    aeson blazeBuilder blazeHtml blazeMarkup caseInsensitive cereal
    clientsession conduit cookie failure fastLogger hamlet httpTypes
    liftedBase monadControl parsec pathPieces random resourcet
    shakespeare shakespeareCss shakespeareI18n shakespeareJs text time
    transformers transformersBase vector wai waiExtra waiLogger
    yesodRoutes
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
