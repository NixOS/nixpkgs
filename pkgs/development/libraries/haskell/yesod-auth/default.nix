{ cabal, aesonNative, authenticate, blazeHtml, controlMonadAttempt
, hamlet, httpEnumerator, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.7.4";
  sha256 = "088hhyy7fwga7hwqqwxxn12iqnz6jadq1bc9p8hdv1jy6ib769dl";
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
