{ cabal, aeson, authenticate, base16Bytestring, blazeHtml
, blazeMarkup, cryptohash, dataDefault, emailValidate, fileEmbed
, hamlet, httpConduit, httpTypes, liftedBase, mimeMail, network
, persistent, persistentTemplate, pwstoreFast, random, resourcet
, safe, shakespeare, shakespeareCss, shakespeareJs, text, time
, transformers, unorderedContainers, wai, yesodCore, yesodForm
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.0.2";
  sha256 = "1lx9xz5jrr63256w64isndwr323khsyyn8ah1iv1vy7n54y9afpk";
  buildDepends = [
    aeson authenticate base16Bytestring blazeHtml blazeMarkup
    cryptohash dataDefault emailValidate fileEmbed hamlet httpConduit
    httpTypes liftedBase mimeMail network persistent persistentTemplate
    pwstoreFast random resourcet safe shakespeare shakespeareCss
    shakespeareJs text time transformers unorderedContainers wai
    yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
