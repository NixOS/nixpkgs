{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, filepath, httpTypes, liftedBase, mimeTypes, monadControl, mtl
, network, random, regexCompat, resourcet, socks, text, time, tls
, tlsExtra, transformers, transformersBase, utf8String, void
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.8.7.1";
  sha256 = "1m0f9snc2zxj8hvxw3ngw0h78ckvdlxxfjvrryk93blfwbamssi5";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault deepseq failure filepath httpTypes liftedBase
    mimeTypes monadControl mtl network random regexCompat resourcet
    socks text time tls tlsExtra transformers transformersBase
    utf8String void zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
