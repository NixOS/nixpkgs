{ cabal, aeson, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cereal, clientsession, conduit, cookie, failure
, fastLogger, hamlet, httpTypes, liftedBase, monadControl, parsec
, pathPieces, random, resourcet, shakespeare, shakespeareCss
, shakespeareI18n, shakespeareJs, text, time, transformers
, transformersBase, vector, wai, waiExtra, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.0.1.2";
  sha256 = "1c9ay0xv2s1kcj92ai0bj1gbml4k4w62n2mw7c5r6m88k8wmxh6z";
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
