{ cabal, aeson, attoparsecConduit, blazeBuilder, blazeHtml
, blazeMarkup, caseInsensitive, cereal, clientsession, conduit
, cookie, dataDefault, failure, fastLogger, hamlet, hspec
, httpTypes, HUnit, liftedBase, monadControl, monadLogger, parsec
, pathPieces, QuickCheck, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareI18n, shakespeareJs, text, time
, transformers, transformersBase, unixCompat, vector, wai, waiExtra
, waiLogger, waiTest, warp, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.2.6.4";
  sha256 = "0s5lc3drm1ayd7mikpn4gkn7c7c9zspgsl5087ia2jlkayzj5n14";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder blazeHtml blazeMarkup
    caseInsensitive cereal clientsession conduit cookie dataDefault
    failure fastLogger hamlet httpTypes liftedBase monadControl
    monadLogger parsec pathPieces random resourcet safe shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase unixCompat vector wai waiExtra waiLogger warp
    yesodRoutes
  ];
  testDepends = [
    blazeBuilder conduit hamlet hspec httpTypes HUnit liftedBase
    QuickCheck random resourcet shakespeareCss shakespeareJs text
    transformers wai waiTest
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
