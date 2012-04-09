{ cabal, base64Bytestring, blazeBuilder, blazeHtml, cryptohash
, fileEmbed, httpDate, httpTypes, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.2.0.1";
  sha256 = "0z3bx6sx3f5k00x0i9lk81a3gh9blnsqw55w89l0pl946fv002pc";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml cryptohash fileEmbed
    httpDate httpTypes text time transformers unixCompat wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
