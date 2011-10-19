{ cabal, attoparsecText, blazeBuilder, blazeHtml, hamlet, httpTypes
, monadControl, parsec, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, unixCompat, wai
, waiExtra, warp, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.9.3";
  sha256 = "1w5fml250i63qhlxkn1bidc3sminmxf98zsdzvdi42sfjx8fdkkx";
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
