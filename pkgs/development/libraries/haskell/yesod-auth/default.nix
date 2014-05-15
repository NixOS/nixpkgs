{ cabal, aeson, authenticate, base16Bytestring, base64Bytestring
, binary, blazeHtml, blazeMarkup, byteable, cryptohash, dataDefault
, emailValidate, fileEmbed, hamlet, httpConduit, httpTypes
, liftedBase, mimeMail, network, persistent, persistentTemplate
, random, resourcet, safe, shakespeare, shakespeareCss
, shakespeareJs, text, time, transformers, unorderedContainers, wai
, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.0.5";
  sha256 = "03vwmc2hql07mfl2s7a3sry82x0y0icr1977p1ljfhinyh35zc6l";
  buildDepends = [
    aeson authenticate base16Bytestring base64Bytestring binary
    blazeHtml blazeMarkup byteable cryptohash dataDefault emailValidate
    fileEmbed hamlet httpConduit httpTypes liftedBase mimeMail network
    persistent persistentTemplate random resourcet safe shakespeare
    shakespeareCss shakespeareJs text time transformers
    unorderedContainers wai yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
