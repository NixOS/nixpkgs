{ cabal, aeson, authenticate, blazeHtml, controlMonadAttempt
, hamlet, httpEnumerator, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, unorderedContainers, wai, yesodCore, yesodForm
, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.7.7";
  sha256 = "0c5icrhi7an7c500y7ply9p1k22gzm5p9rw33szgc78h5p3jwwcg";
  buildDepends = [
    aeson authenticate blazeHtml controlMonadAttempt hamlet
    httpEnumerator mimeMail persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss text transformers
    unorderedContainers wai yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
