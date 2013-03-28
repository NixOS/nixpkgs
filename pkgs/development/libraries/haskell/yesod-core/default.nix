{ cabal, aeson, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cereal, clientsession, conduit, cookie, failure
, fastLogger, hamlet, hspec, httpTypes, HUnit, liftedBase
, monadControl, monadLogger, parsec, pathPieces, QuickCheck, random
, resourcet, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiTest, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.1.8.2";
  sha256 = "0brrvij1vldb5zr3vnynikaf1x479qrgf7k3162nhrmwl57lm9sz";
  buildDepends = [
    aeson blazeBuilder blazeHtml blazeMarkup caseInsensitive cereal
    clientsession conduit cookie failure fastLogger hamlet httpTypes
    liftedBase monadControl monadLogger parsec pathPieces random
    resourcet shakespeare shakespeareCss shakespeareI18n shakespeareJs
    text time transformers transformersBase vector wai waiExtra
    yesodRoutes
  ];
  testDepends = [
    blazeBuilder conduit hamlet hspec httpTypes HUnit QuickCheck random
    shakespeareCss shakespeareJs text transformers wai waiTest
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
