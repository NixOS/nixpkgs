{ cabal, aeson, blazeHtml, blazeMarkup, dataDefault, hamlet
, monadControl, networkConduit, safe, shakespeareCss, shakespeareJs
, text, transformers, unorderedContainers, wai, waiExtra, warp
, yaml, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.4";
  sha256 = "0c8z4hsplfjb2ilrk0qbyighjipwcfhf55xqaw4zqvq752yj4n7c";
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
