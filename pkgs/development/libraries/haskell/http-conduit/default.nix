{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, httpTypes, liftedBase, monadControl, mtl, network, regexCompat
, resourcet, socks, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.6.0.1";
  sha256 = "0v6r57pliaam3i69826bf07iqmkm2s2x6f19mk0amh7fvdfjhgyb";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault deepseq failure httpTypes liftedBase
    monadControl mtl network regexCompat resourcet socks text time tls
    tlsExtra transformers transformersBase utf8String void zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
