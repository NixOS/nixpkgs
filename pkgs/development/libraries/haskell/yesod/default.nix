{ cabal, aeson, blazeHtml, blazeMarkup, dataDefault, hamlet
, monadControl, networkConduit, safe, shakespeareCss, shakespeareJs
, text, transformers, unorderedContainers, wai, waiExtra, warp
, yaml, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.1";
  sha256 = "19gwhav6sr6gd2kh92ga8a09hq9grllmnacdqkgasxwjsfxqa6zg";
  buildDepends = [
    aeson blazeHtml blazeMarkup dataDefault hamlet monadControl
    networkConduit safe shakespeareCss shakespeareJs text transformers
    unorderedContainers wai waiExtra warp yaml yesodAuth yesodCore
    yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
