{ cabal, base64Bytestring, blazeBuilder, blazeHtml, cryptohash
, fileEmbed, httpDate, httpTypes, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "0.3.4";
  sha256 = "0jxlm0qfv59c3q6ngvr94rzrn01byfn3wak208ws18xhk14cv058";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml cryptohash fileEmbed
    httpDate httpTypes text time transformers unixCompat wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
