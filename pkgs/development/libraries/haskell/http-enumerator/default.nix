{ cabal, asn1Data, attoparsec, attoparsecEnumerator
, base64Bytestring, blazeBuilder, blazeBuilderEnumerator
, caseInsensitive, certificate, cprngAes, enumerator, failure
, httpTypes, monadControl, network, tls, tlsExtra, transformers
, utf8String, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-enumerator";
  version = "0.6.5.6";
  sha256 = "1b2hfqya562f2aj5fh9abr9zq4gx327jdlyja5wzcx01hzlavvcn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data attoparsec attoparsecEnumerator base64Bytestring
    blazeBuilder blazeBuilderEnumerator caseInsensitive certificate
    cprngAes enumerator failure httpTypes monadControl network tls
    tlsExtra transformers utf8String zlibEnum
  ];
  meta = {
    homepage = "http://github.com/snoyberg/http-enumerator";
    description = "HTTP client package with enumerator interface and HTTPS support.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
