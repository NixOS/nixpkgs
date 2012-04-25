{ cabal, attoparsec, blazeBuilder, blazeHtml, Cabal, fastLogger
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers
, unixCompat, wai, waiExtra, waiLogger, warp, yesodAuth, yesodCore
, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.0.1.3";
  sha256 = "0pbfvaza4q8znnxpkh9fb1fys09byws9n34lv0rs70nrbdq5yp5r";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml Cabal fastLogger filepath hamlet
    httpTypes monadControl parsec shakespeareCss shakespeareJs
    shakespeareText text time transformers unixCompat wai waiExtra
    waiLogger warp yesodAuth yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
