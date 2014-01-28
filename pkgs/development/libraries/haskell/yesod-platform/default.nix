{ cabal, aeson, ansiTerminal, asn1Data, asn1Types, attoparsec
, attoparsecConduit, authenticate, base64Bytestring
, baseUnicodeSymbols, blazeBuilder, blazeBuilderConduit, blazeHtml
, blazeMarkup, byteable, byteorder, caseInsensitive, cereal
, certificate, cipherAes, cipherBlowfish, cipherCamellia, cipherDes
, cipherRc4, clientsession, conduit, connection, controlMonadLoop
, cookie, cprngAes, cryptoApi, cryptocipher, cryptoCipherTypes
, cryptoConduit, cryptohash, cryptohashCryptoapi, cryptoNumbers
, cryptoPubkey, cryptoPubkeyTypes, cryptoRandom, cryptoRandomApi
, cssText, dataDefault, dataDefaultClass, dataDefaultInstancesBase
, dataDefaultInstancesContainers, dataDefaultInstancesDlist
, dataDefaultInstancesOldLocale, dlist, emailValidate, entropy
, esqueleto, failure, fastLogger, fileEmbed, filesystemConduit
, hamlet, hjsmin, hspec, hspecExpectations, htmlConduit
, httpAttoparsec, httpClient, httpClientConduit, httpClientTls
, httpConduit, httpDate, httpTypes, languageJavascript, liftedBase
, mimeMail, mimeTypes, mmorph, monadControl, monadLogger
, monadLoops, networkConduit, pathPieces, pem, persistent
, persistentTemplate, poolConduit, primitive, processConduit
, publicsuffixlist, pureMD5, pwstoreFast, quickcheckIo
, resourcePool, resourcet, safe, scientific, securemem, semigroups
, setenv, SHA, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, shakespeareText, silently, simpleSendfile, skein
, socks, stmChans, stringsearch, systemFileio, systemFilepath
, tagged, tagsoup, tagstreamConduit, tls, tlsExtra
, transformersBase, unixCompat, unorderedContainers, utf8Light
, utf8String, vector, void, wai, waiAppStatic, waiExtra, waiLogger
, waiTest, warp, warpTls, word8, xmlConduit, xmlTypes, xssSanitize
, yaml, yesod, yesodAuth, yesodCore, yesodForm, yesodPersistent
, yesodRoutes, yesodStatic, yesodTest, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "yesod-platform";
  version = "1.2.6.1";
  sha256 = "1hwvpyxwirv9maangw4q6nb2m2kqpqvvh1i095fr08f1a1qih77f";
  buildDepends = [
    aeson ansiTerminal asn1Data asn1Types attoparsec attoparsecConduit
    authenticate base64Bytestring baseUnicodeSymbols blazeBuilder
    blazeBuilderConduit blazeHtml blazeMarkup byteable byteorder
    caseInsensitive cereal certificate cipherAes cipherBlowfish
    cipherCamellia cipherDes cipherRc4 clientsession conduit connection
    controlMonadLoop cookie cprngAes cryptoApi cryptocipher
    cryptoCipherTypes cryptoConduit cryptohash cryptohashCryptoapi
    cryptoNumbers cryptoPubkey cryptoPubkeyTypes cryptoRandom
    cryptoRandomApi cssText dataDefault dataDefaultClass
    dataDefaultInstancesBase dataDefaultInstancesContainers
    dataDefaultInstancesDlist dataDefaultInstancesOldLocale dlist
    emailValidate entropy esqueleto failure fastLogger fileEmbed
    filesystemConduit hamlet hjsmin hspec hspecExpectations htmlConduit
    httpAttoparsec httpClient httpClientConduit httpClientTls
    httpConduit httpDate httpTypes languageJavascript liftedBase
    mimeMail mimeTypes mmorph monadControl monadLogger monadLoops
    networkConduit pathPieces pem persistent persistentTemplate
    poolConduit primitive processConduit publicsuffixlist pureMD5
    pwstoreFast quickcheckIo resourcePool resourcet safe scientific
    securemem semigroups setenv SHA shakespeare shakespeareCss
    shakespeareI18n shakespeareJs shakespeareText silently
    simpleSendfile skein socks stmChans stringsearch systemFileio
    systemFilepath tagged tagsoup tagstreamConduit tls tlsExtra
    transformersBase unixCompat unorderedContainers utf8Light
    utf8String vector void wai waiAppStatic waiExtra waiLogger waiTest
    warp warpTls word8 xmlConduit xmlTypes xssSanitize yaml yesod
    yesodAuth yesodCore yesodForm yesodPersistent yesodRoutes
    yesodStatic yesodTest zlibBindings zlibConduit
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Meta package for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
