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
  version = "1.9.5";
  sha256 = "01xmm63cbdm20wp6bpp3052zfpqmvglcq33skhy92cqkpgvd7f8y";
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
