{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, network, persistent
, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.1.7";
  sha256 = "09d999sqsm6v59l9q2gh09ar2vl601csr6w8mkcmgax5bdb26waz";
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
