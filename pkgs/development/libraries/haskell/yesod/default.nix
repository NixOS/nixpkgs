{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup, Cabal
, fastLogger, filepath, hamlet, httpTypes, monadControl, parsec
, shakespeareCss, shakespeareJs, shakespeareText, text, time
, transformers, unixCompat, wai, waiExtra, waiLogger, warp
, yesodAuth, yesodCore, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.0.1.6";
  sha256 = "0w5k5bcv50fjpyja6ydknk78dk50swx6b0myhizj8rcf851xga43";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup Cabal fastLogger
    filepath hamlet httpTypes monadControl parsec shakespeareCss
    shakespeareJs shakespeareText text time transformers unixCompat wai
    waiExtra waiLogger warp yesodAuth yesodCore yesodForm yesodJson
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
