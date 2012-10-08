{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, unorderedContainers, wai, yesodCore, yesodForm
, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.1.1";
  sha256 = "1ryq3jxcgb55ijjmcv0j234n9nay2ianifb59gz9akyv0sc3zcl9";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    liftedBase mimeMail persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss text transformers
    unorderedContainers wai yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
