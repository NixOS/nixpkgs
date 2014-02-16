{ cabal, aeson, blazeHtml, blazeMarkup, dataDefault, fastLogger
, hamlet, monadControl, monadLogger, networkConduit, safe
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, waiExtra, warp, yaml, yesodAuth
, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.5";
  sha256 = "0vcszhd8vasfpm754bz1vyarhlkffj3kbrfcq9q5gqmm389jfpk2";
  buildDepends = [
    aeson blazeHtml blazeMarkup dataDefault fastLogger hamlet
    monadControl monadLogger networkConduit safe shakespeareCss
    shakespeareJs text transformers unorderedContainers wai waiExtra
    warp yaml yesodAuth yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
