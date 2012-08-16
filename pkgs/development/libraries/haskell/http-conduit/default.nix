{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, httpTypes, liftedBase, monadControl, mtl, network, regexCompat
, resourcet, socks, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, void, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.5.0.3";
  sha256 = "1l00wyisb5jkq1c2ikzq0iwhjx6s66bz5s8gricfbrr15bdx1iay";
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
