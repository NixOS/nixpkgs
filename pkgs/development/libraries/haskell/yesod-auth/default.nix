{ cabal, aesonNative, authenticate, blazeHtml, controlMonadAttempt
, hamlet, httpEnumerator, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.7.1";
  sha256 = "066aq7c5gwbspbib748ky3lsb84llnb954n018fk5xs7b4gbyybk";
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
