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
  version = "1.2.16.1";
  sha256 = "1wr5labhp3wc23ki2wvaypanm54qw9vz3v77rxyj1za1y2n1cprw";
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
