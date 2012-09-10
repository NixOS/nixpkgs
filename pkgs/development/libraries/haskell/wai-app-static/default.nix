{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoConduit, cryptohash, fileEmbed, httpDate, httpTypes
, mimeTypes, systemFileio, systemFilepath, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.0";
  sha256 = "1xsjq0xip9anbd4cpami8w6d2p0pdp375hzw1jx6pvajjmkjksqn";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoConduit cryptohash fileEmbed httpDate httpTypes mimeTypes
    systemFileio systemFilepath text time transformers unixCompat wai
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
