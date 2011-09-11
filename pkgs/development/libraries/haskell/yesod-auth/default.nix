{ cabal, aesonNative, authenticate, blazeHtml, controlMonadAttempt
, hamlet, httpEnumerator, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.7.2";
  sha256 = "18i1ijxrhmmxy45ymc89f7m2zazd7lca4jv4q08d7mr1hdgsx8cn";
  buildDepends = [
    aesonNative authenticate blazeHtml controlMonadAttempt hamlet
    httpEnumerator mimeMail persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss text transformers wai
    yesodCore yesodForm yesodJson yesodPersistent
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
