{ cabal, aeson, async, attoparsecConduit, blazeBuilder, blazeHtml
, blazeMarkup, caseInsensitive, cereal, clientsession, conduit
, conduitExtra, cookie, dataDefault, deepseq, exceptions
, fastLogger, hamlet, hspec, httpTypes, HUnit, liftedBase
, monadControl, monadLogger, mtl, network, networkConduit, parsec
, pathPieces, QuickCheck, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareI18n, shakespeareJs, streamingCommons
, text, time, transformers, transformersBase, unixCompat, vector
, wai, waiExtra, waiLogger, waiTest, warp, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.2.17";
  sha256 = "199zj9yz5nmk4h2dwz4zlix3wf1z5fl9a8jg8cr4z6ldgskcfis1";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder blazeHtml blazeMarkup
    caseInsensitive cereal clientsession conduit conduitExtra cookie
    dataDefault deepseq exceptions fastLogger hamlet httpTypes
    liftedBase monadControl monadLogger mtl parsec pathPieces random
    resourcet safe shakespeare shakespeareCss shakespeareI18n
    shakespeareJs text time transformers transformersBase unixCompat
    vector wai waiExtra waiLogger warp yesodRoutes
  ];
  testDepends = [
    async blazeBuilder conduit conduitExtra hamlet hspec httpTypes
    HUnit liftedBase network networkConduit QuickCheck random resourcet
    shakespeare shakespeareCss shakespeareJs streamingCommons text
    transformers wai waiExtra waiTest
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
