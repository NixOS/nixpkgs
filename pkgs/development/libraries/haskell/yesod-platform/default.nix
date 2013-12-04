{ cabal, aeson, ansiTerminal, asn1Data, asn1Types, attoparsec
, attoparsecConduit, authenticate, base64Bytestring
, baseUnicodeSymbols, blazeBuilder, blazeBuilderConduit, blazeHtml
, blazeMarkup, byteable, byteorder, caseInsensitive, cereal
, certificate, cipherAes, cipherRc4, clientsession, conduit, cookie
, cprngAes, cryptoApi, cryptoCipherTypes, cryptoConduit, cryptohash
, cryptohashCryptoapi, cryptoNumbers, cryptoPubkey
, cryptoPubkeyTypes, cryptoRandom, cssText, dataDefault
, dataDefaultClass, dataDefaultInstancesBase
, dataDefaultInstancesContainers, dataDefaultInstancesDlist
, dataDefaultInstancesOldLocale, dateCache, dlist, emailValidate
, entropy, failure, fastLogger, fileEmbed, filesystemConduit
, hamlet, hjsmin, hspec, hspecExpectations, htmlConduit
, httpAttoparsec, httpConduit, httpDate, httpTypes
, languageJavascript, liftedBase, mimeMail, mimeTypes, mmorph
, monadControl, monadLogger, networkConduit, pathPieces, pem
, persistent, persistentTemplate, poolConduit, primitive
, publicsuffixlist, pureMD5, pwstoreFast, quickcheckIo
, resourcePool, resourcet, safe, securemem, semigroups, setenv, SHA
, shakespeare, shakespeareCss, shakespeareI18n, shakespeareJs
, shakespeareText, silently, simpleSendfile, skein, socks
, stringsearch, systemFileio, systemFilepath, tagged, tagsoup
, tagstreamConduit, tls, tlsExtra, transformersBase, unixCompat
, unorderedContainers, utf8Light, utf8String, vector, void, wai
, waiAppStatic, waiExtra, waiLogger, waiTest, warp, word8
, xmlConduit, xmlTypes, xssSanitize, yaml, yesod, yesodAuth
, yesodCore, yesodForm, yesodPersistent, yesodRoutes, yesodStatic
, yesodTest, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "yesod-platform";
  version = "1.2.4.4";
  sha256 = "0avqaqx81rald37j4qxp75ixgq5q4a3b8fnlmfsp9d54nfp3hxji";
  buildDepends = [
    aeson ansiTerminal asn1Data asn1Types attoparsec attoparsecConduit
    authenticate base64Bytestring baseUnicodeSymbols blazeBuilder
    blazeBuilderConduit blazeHtml blazeMarkup byteable byteorder
    caseInsensitive cereal certificate cipherAes cipherRc4
    clientsession conduit cookie cprngAes cryptoApi cryptoCipherTypes
    cryptoConduit cryptohash cryptohashCryptoapi cryptoNumbers
    cryptoPubkey cryptoPubkeyTypes cryptoRandom cssText dataDefault
    dataDefaultClass dataDefaultInstancesBase
    dataDefaultInstancesContainers dataDefaultInstancesDlist
    dataDefaultInstancesOldLocale dateCache dlist emailValidate entropy
    failure fastLogger fileEmbed filesystemConduit hamlet hjsmin hspec
    hspecExpectations htmlConduit httpAttoparsec httpConduit httpDate
    httpTypes languageJavascript liftedBase mimeMail mimeTypes mmorph
    monadControl monadLogger networkConduit pathPieces pem persistent
    persistentTemplate poolConduit primitive publicsuffixlist pureMD5
    pwstoreFast quickcheckIo resourcePool resourcet safe securemem
    semigroups setenv SHA shakespeare shakespeareCss shakespeareI18n
    shakespeareJs shakespeareText silently simpleSendfile skein socks
    stringsearch systemFileio systemFilepath tagged tagsoup
    tagstreamConduit tls tlsExtra transformersBase unixCompat
    unorderedContainers utf8Light utf8String vector void wai
    waiAppStatic waiExtra waiLogger waiTest warp word8 xmlConduit
    xmlTypes xssSanitize yaml yesod yesodAuth yesodCore yesodForm
    yesodPersistent yesodRoutes yesodStatic yesodTest zlibBindings
    zlibConduit
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Meta package for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
