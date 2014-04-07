{ cabal, aeson, async, attoparsecConduit, blazeBuilder, blazeHtml
, blazeMarkup, caseInsensitive, cereal, clientsession, conduit
, conduitExtra, cookie, dataDefault, fastLogger, hamlet, hspec
, httpTypes, HUnit, liftedBase, monadControl, monadLogger, mtl
, network, networkConduit, parsec, pathPieces, QuickCheck, random
, resourcet, safe, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, streamingCommons, text, time, transformers
, transformersBase, unixCompat, vector, wai, waiExtra, waiLogger
, waiTest, warp, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.2.11";
  sha256 = "0vg07g5735qsr01wpgxpjzjc7w9nrqvkhfnd90jzdvg3kg33dgih";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder blazeHtml blazeMarkup
    caseInsensitive cereal clientsession conduit conduitExtra cookie
    dataDefault fastLogger hamlet httpTypes liftedBase monadControl
    monadLogger mtl parsec pathPieces random resourcet safe shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase unixCompat vector wai waiExtra waiLogger warp
    yesodRoutes
  ];
  testDepends = [
    async blazeBuilder conduit conduitExtra hamlet hspec httpTypes
    HUnit liftedBase network networkConduit QuickCheck random resourcet
    shakespeare shakespeareCss shakespeareJs streamingCommons text
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
