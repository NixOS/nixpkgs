{ cabal, attoparsec, blazeBuilder, blazeHtml, Cabal, fastLogger
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers
, unixCompat, wai, waiExtra, waiLogger, warp, yesodAuth, yesodCore
, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.10.1.3";
  sha256 = "01r9b88gsj7f1mn56nm5dyzj2s46l9pg9p7fjwkf0l8zdfmrbflw";
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
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
