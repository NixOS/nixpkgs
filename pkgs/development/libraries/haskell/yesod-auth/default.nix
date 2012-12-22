{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, network, persistent
, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.2.2";
  sha256 = "16g2lnnwp5219i77fb4pv2y8ljz4msflj38mvh0zw3x93747baf7";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    liftedBase mimeMail network persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss shakespeareJs text
    transformers unorderedContainers wai yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
