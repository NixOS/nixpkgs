{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoApi, cryptoConduit, cryptohashCryptoapi, fileEmbed
, hspec, httpDate, httpTypes, mimeTypes, network, systemFileio
, systemFilepath, text, time, transformers, unixCompat, wai
, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.1.4";
  sha256 = "1457643xkigqnacg1fw25jp9kjqiy55d22ll8fml07bxs37hlr63";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoApi cryptoConduit cryptohashCryptoapi fileEmbed httpDate
    httpTypes mimeTypes systemFileio systemFilepath text time
    transformers unixCompat wai
  ];
  testDepends = [
    hspec httpDate httpTypes mimeTypes network text time transformers
    unixCompat wai waiTest
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
