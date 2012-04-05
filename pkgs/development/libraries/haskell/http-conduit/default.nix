{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, failure, httpTypes
, liftedBase, monadControl, mtl, network, regexCompat, resourcet
, socks, text, time, tls, tlsExtra, transformers, transformersBase
, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.4.0.2";
  sha256 = "1zhsz9zqa4h5f18yalihcqa5p4ji50b8cw7h88i9s46q3fwcrbhh";
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
