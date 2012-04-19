{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, failure, httpTypes
, liftedBase, monadControl, mtl, network, regexCompat, resourcet
, socks, text, time, tls, tlsExtra, transformers, transformersBase
, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.4.1.2";
  sha256 = "1ji7pdqrzhzlmy2ig21s8fcfcqa29lc9k56l29zkw9qqgdaq5x3s";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault failure httpTypes liftedBase monadControl mtl
    network regexCompat resourcet socks text time tls tlsExtra
    transformers transformersBase utf8String void zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
