{ cabal, asn1Data, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, certificate, conduit
, cookie, cprngAes, dataDefault, deepseq, failure, filepath, hspec
, httpTypes, HUnit, liftedBase, mimeTypes, monadControl, mtl
, network, networkConduit, publicsuffixlist, random, regexCompat
, resourcet, socks, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, void, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.9.4.1";
  sha256 = "181irzldrr554naq2yvs0yzmkkfk26n59snrsmxhr79d9kdp73l4";
  buildDepends = [
    asn1Data base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive certificate conduit cookie cprngAes dataDefault
    deepseq failure filepath httpTypes liftedBase mimeTypes
    monadControl mtl network publicsuffixlist random regexCompat
    resourcet socks text time tls tlsExtra transformers
    transformersBase utf8String void zlibConduit
  ];
  testDepends = [
    asn1Data base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive certificate conduit cookie cprngAes dataDefault
    deepseq failure filepath hspec httpTypes HUnit liftedBase mimeTypes
    monadControl mtl network networkConduit publicsuffixlist random
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
