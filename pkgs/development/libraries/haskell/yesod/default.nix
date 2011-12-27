{ cabal, attoparsec, blazeBuilder, blazeHtml, hamlet, httpTypes
, monadControl, parsec, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, unixCompat, wai
, waiExtra, warp, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.9.4.1";
  sha256 = "0dcd4m91liash046i0qaq51s447sl4fn55gsg7mi807lffik436q";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml hamlet httpTypes monadControl
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
