{ cabal, aeson, attoparsecConduit, blazeBuilder, blazeHtml
, blazeMarkup, caseInsensitive, cereal, clientsession, conduit
, cookie, dataDefault, failure, fastLogger, hamlet, hspec
, httpTypes, HUnit, liftedBase, monadControl, monadLogger, parsec
, pathPieces, QuickCheck, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareI18n, shakespeareJs, text, time
, transformers, transformersBase, vector, wai, waiExtra, waiTest
, warp, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.2.4.3";
  sha256 = "0p4bgpa1xb4s7yma16lw74gwm5865npdcc0djg1i4xp57q4d3dh6";
  buildDepends = [
    aeson attoparsecConduit blazeBuilder blazeHtml blazeMarkup
    caseInsensitive cereal clientsession conduit cookie dataDefault
    failure fastLogger hamlet httpTypes liftedBase monadControl
    monadLogger parsec pathPieces random resourcet safe shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra warp yesodRoutes
  ];
  testDepends = [
    blazeBuilder conduit hamlet hspec httpTypes HUnit liftedBase
    QuickCheck random resourcet shakespeareCss shakespeareJs text
    transformers wai waiTest
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
