{ cabal, aeson, async, attoparsecConduit, blazeBuilder, blazeHtml
, blazeMarkup, caseInsensitive, cereal, clientsession, conduit
, cookie, dataDefault, fastLogger, hamlet, hspec, httpTypes, HUnit
, liftedBase, monadControl, monadLogger, network, networkConduit
, parsec, pathPieces, QuickCheck, random, resourcet, safe
, shakespeare, shakespeareCss, shakespeareI18n, shakespeareJs, text
, time, transformers, transformersBase, unixCompat, vector, wai
, waiExtra, waiLogger, waiTest, warp, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.2.9.1";
  sha256 = "1j37jf82csdvjgb36034c0pqrmzd5r131hfqh43jp4m1wqsrib5k";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder blazeHtml blazeMarkup
    caseInsensitive cereal clientsession conduit cookie dataDefault
    fastLogger hamlet httpTypes liftedBase monadControl monadLogger
    parsec pathPieces random resourcet safe shakespeare shakespeareCss
    shakespeareI18n shakespeareJs text time transformers
    transformersBase unixCompat vector wai waiExtra waiLogger warp
    yesodRoutes
  ];
  testDepends = [
    async blazeBuilder conduit hamlet hspec httpTypes HUnit liftedBase
    network networkConduit QuickCheck random resourcet shakespeareCss
    shakespeareJs text transformers wai waiTest
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
