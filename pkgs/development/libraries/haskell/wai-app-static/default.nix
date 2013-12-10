{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoApi, cryptoConduit, cryptohashCryptoapi, fileEmbed
, filepath, hspec, httpDate, httpTypes, mimeTypes, network
, systemFileio, systemFilepath, text, time, transformers
, unixCompat, unorderedContainers, wai, waiTest, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "2.0.0.1";
  sha256 = "0c02j61a62dpl9i736q8cv0b9kw17akkws7waqa4zcbad1wyiqps";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoApi cryptoConduit cryptohashCryptoapi fileEmbed filepath
    httpDate httpTypes mimeTypes systemFileio systemFilepath text time
    transformers unixCompat unorderedContainers wai zlib
  ];
  testDepends = [
    hspec httpDate httpTypes mimeTypes network text time transformers
    unixCompat wai waiTest zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
