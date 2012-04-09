{ cabal, attoparsec, blazeBuilder, blazeHtml, Cabal, fastLogger
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers
, unixCompat, wai, waiExtra, waiLogger, warp, yesodAuth, yesodCore
, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.0.0.2";
  sha256 = "171a7nbcz48ykdn9sz6gzpnkjhv2n75c8v9gdlp9slbnmbphq94p";
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
