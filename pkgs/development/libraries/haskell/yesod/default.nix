{ cabal, attoparsecText, blazeBuilder, blazeHtml, hamlet, httpTypes
, monadControl, parsec, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, unixCompat, wai
, waiExtra, warp, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.9.3.1";
  sha256 = "0af4nyfrpvkyr070fkg1qf4pn783n5443j8hi3wqn4i371vqsmp0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsecText blazeBuilder blazeHtml hamlet httpTypes monadControl
    parsec shakespeareCss shakespeareJs shakespeareText text time
    transformers unixCompat wai waiExtra warp yesodAuth yesodCore
    yesodForm yesodJson yesodPersistent
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
