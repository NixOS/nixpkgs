{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, httpTypes, liftedBase, monadControl, mtl, network, regexCompat
, resourcet, socks, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.4.1.10";
  sha256 = "0a2014bzh4vvm3qx5yarxgirzlngzy2xrwpi3bvnz1h3q0hggq01";
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
