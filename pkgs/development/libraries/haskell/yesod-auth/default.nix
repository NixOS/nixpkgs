{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, httpTypes, liftedBase, mimeMail, network, persistent
, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.4.1";
  sha256 = "18x2m1clk3nqaap51c6ayxbh5q6v0i4srcphgyf26lrxq514pvad";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    httpTypes liftedBase mimeMail network persistent persistentTemplate
    pureMD5 pwstoreFast random SHA shakespeareCss shakespeareJs text
    transformers unorderedContainers wai yesodCore yesodForm yesodJson
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
