{ cabal, aeson, blazeHtml, blazeMarkup, conduitExtra, dataDefault
, fastLogger, hamlet, monadControl, monadLogger, networkConduit
, safe, shakespeare, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.6";
  sha256 = "0rw46zznczdzg2wvbgp5kpq3yrl6w40vbbs7zyvqpcf6m82jsfz0";
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
