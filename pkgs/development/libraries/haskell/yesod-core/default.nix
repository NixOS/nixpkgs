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
  version = "1.1.8";
  sha256 = "03yk9ypd314830bk3jjwkzi87bn04lqkh6hq91izn1prvijjiqjm";
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
