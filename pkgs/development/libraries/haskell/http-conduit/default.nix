{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, filepath, hspec, httpTypes, HUnit, liftedBase, mimeTypes
, monadControl, mtl, network, networkConduit, random, regexCompat
, resourcet, socks, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, void, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.8.9";
  sha256 = "0v99nc29h4qm1dbs7bwk4nwhxwk22vzl4ghrq9r3vishi6gwr7hb";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault deepseq failure filepath httpTypes liftedBase
    mimeTypes monadControl mtl network random regexCompat resourcet
    socks text time tls tlsExtra transformers transformersBase
    utf8String void zlibConduit
  ];
  testDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault deepseq failure filepath hspec httpTypes HUnit
    liftedBase mimeTypes monadControl mtl network networkConduit random
    regexCompat resourcet socks text time tls tlsExtra transformers
    transformersBase utf8String void wai warp zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
