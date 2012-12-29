{ cabal, aeson, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cereal, clientsession, conduit, cookie, failure
, fastLogger, hamlet, httpTypes, liftedBase, monadControl
, monadLogger, parsec, pathPieces, random, resourcet, shakespeare
, shakespeareCss, shakespeareI18n, shakespeareJs, text, time
, transformers, transformersBase, vector, wai, waiExtra
, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.1.7";
  sha256 = "1z47h7ghhi8mvmrc0rcwb3si1bq4623i5x127k8fahcy6qk4qls8";
  buildDepends = [
    aeson blazeBuilder blazeHtml blazeMarkup caseInsensitive cereal
    clientsession conduit cookie failure fastLogger hamlet httpTypes
    liftedBase monadControl monadLogger parsec pathPieces random
    resourcet shakespeare shakespeareCss shakespeareI18n shakespeareJs
    text time transformers transformersBase vector wai waiExtra
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
