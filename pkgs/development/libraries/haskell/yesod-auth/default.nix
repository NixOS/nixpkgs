{ cabal, SHA, aeson, authenticate, blazeHtml, controlMonadAttempt
, hamlet, httpEnumerator, mimeMail, persistent, persistentTemplate
, pureMD5, text, transformers, wai, webRoutesQuasi, yesodCore
, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.4.0.2";
  sha256 = "1vf02kgm3pcak4igvp8009lgv8i8bir272byw0ma2mg6bl0sgyvl";
  buildDepends = [
    SHA aeson authenticate blazeHtml controlMonadAttempt hamlet
    httpEnumerator mimeMail persistent persistentTemplate pureMD5 text
    transformers wai webRoutesQuasi yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
