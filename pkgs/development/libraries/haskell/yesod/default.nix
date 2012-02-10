{ cabal, attoparsec, blazeBuilder, blazeHtml, fastLogger, hamlet
, httpTypes, monadControl, parsec, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, unixCompat, wai
, waiExtra, waiLogger, warp, yesodAuth, yesodCore, yesodForm
, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.10.1";
  sha256 = "1m4prrpxdcj7qn755as37kn66f7didparhar520anr9cryn0wfr9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml fastLogger hamlet httpTypes
    monadControl parsec shakespeareCss shakespeareJs shakespeareText
    text time transformers unixCompat wai waiExtra waiLogger warp
    yesodAuth yesodCore yesodForm yesodJson yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
