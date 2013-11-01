{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoApi, cryptoConduit, cryptohashCryptoapi, fileEmbed
, hspec, httpDate, httpTypes, mimeTypes, network, systemFileio
, systemFilepath, text, time, transformers, unixCompat
, unorderedContainers, wai, waiTest, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.3";
  sha256 = "0lsqfvlh65rggp9z6m5gyx8gv0wk3b44jrk57s8yj2bh74pbr64f";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoApi cryptoConduit cryptohashCryptoapi fileEmbed httpDate
    httpTypes mimeTypes systemFileio systemFilepath text time
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
