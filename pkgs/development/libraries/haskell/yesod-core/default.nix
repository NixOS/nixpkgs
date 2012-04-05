{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, conduit, cookie, failure, fastLogger, hamlet
, httpTypes, liftedBase, monadControl, parsec, pathPieces, random
, resourcet, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.0.0";
  sha256 = "0za3pflbcmgxd45jx0g2yc7cmhmhn1qk45j0mg4qq73r1lcyj6x0";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    conduit cookie failure fastLogger hamlet httpTypes liftedBase
    monadControl parsec pathPieces random resourcet shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra waiLogger yesodRoutes
  ];
  noHaddock = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
