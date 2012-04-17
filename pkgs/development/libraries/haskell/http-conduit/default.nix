{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, failure, httpTypes
, liftedBase, monadControl, mtl, network, regexCompat, resourcet
, socks, text, time, tls, tlsExtra, transformers, transformersBase
, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.4.1";
  sha256 = "1jv5nk2h17hf2fp1r6ych9grnlx2hsclxgn10d5f1vx21xbd0hkl";
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
