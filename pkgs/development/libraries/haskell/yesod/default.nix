{ cabal, attoparsec, blazeBuilder, blazeHtml, hamlet, httpTypes
, monadControl, parsec, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, unixCompat, wai
, waiExtra, warp, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.9.3.3";
  sha256 = "11xjj9madb9dxk06z3izzbv3cish748hkf57k37mjsvlidbxd104";
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
