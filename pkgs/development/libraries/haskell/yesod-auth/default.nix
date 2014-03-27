{ cabal, aeson, authenticate, base16Bytestring, blazeHtml
, blazeMarkup, cryptohash, dataDefault, emailValidate, fileEmbed
, hamlet, httpConduit, httpTypes, liftedBase, mimeMail, network
, persistent, persistentTemplate, pwstoreFast, random, resourcet
, safe, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.0.1";
  sha256 = "0c9vrjn7ypwqidyz65icr0i8xb956gaga8jbqrwvc9x624brxhxy";
  buildDepends = [
    aeson authenticate base16Bytestring blazeHtml blazeMarkup
    cryptohash dataDefault emailValidate fileEmbed hamlet httpConduit
    httpTypes liftedBase mimeMail network persistent persistentTemplate
    pwstoreFast random resourcet safe shakespeareCss shakespeareJs text
    time transformers unorderedContainers wai yesodCore yesodForm
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
