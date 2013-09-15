{ cabal, aeson, blazeHtml, blazeMarkup, dataDefault, hamlet
, monadControl, networkConduit, safe, shakespeareCss, shakespeareJs
, text, transformers, unorderedContainers, wai, waiExtra, warp
, yaml, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.2.1";
  sha256 = "0xhpsqfshnay7kaz0czr7ass84cbjlgz2n13jk08hs8g8dw72as4";
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
