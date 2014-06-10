{ cabal, aeson, blazeHtml, blazeMarkup, conduitExtra, dataDefault
, fastLogger, hamlet, monadControl, monadLogger, networkConduit
, safe, shakespeare, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.5.3";
  sha256 = "1w9bbvinnbnhrajjqj6yhy9dgggdf6n98x04dys45anssiwrd2ss";
  buildDepends = [
    aeson blazeHtml blazeMarkup conduitExtra dataDefault fastLogger
    hamlet monadControl monadLogger networkConduit safe shakespeare
    shakespeareCss shakespeareJs text transformers unorderedContainers
    wai waiExtra warp yaml yesodAuth yesodCore yesodForm
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
