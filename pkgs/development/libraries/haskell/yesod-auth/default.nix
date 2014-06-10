{ cabal, aeson, attoparsecConduit, authenticate, base16Bytestring
, base64Bytestring, binary, blazeBuilder, blazeHtml, blazeMarkup
, byteable, conduit, conduitExtra, cryptohash, dataDefault
, emailValidate, fileEmbed, hamlet, httpClient, httpConduit
, httpTypes, liftedBase, mimeMail, network, persistent
, persistentTemplate, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.1";
  sha256 = "1fv5z938rpiyhkl4zjb2ss496bgqvdvn7di5im089zmxvx1m81lz";
  buildDepends = [
    aeson attoparsecConduit authenticate base16Bytestring
    base64Bytestring binary blazeBuilder blazeHtml blazeMarkup byteable
    conduit conduitExtra cryptohash dataDefault emailValidate fileEmbed
    hamlet httpClient httpConduit httpTypes liftedBase mimeMail network
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
