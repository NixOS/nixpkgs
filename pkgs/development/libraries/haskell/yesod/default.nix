{ cabal, aeson, blazeHtml, blazeMarkup, conduitExtra, dataDefault
, fastLogger, hamlet, monadControl, monadLogger, networkConduit
, safe, shakespeare, shakespeareCss, shakespeareJs, text
, transformers, unorderedContainers, wai, waiExtra, warp, yaml
, yesodAuth, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.2.5.2";
  sha256 = "0vvpzyfwzgnnd8h60pqz5z1474isp487p43vx7cyzhj423c50p6r";
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
