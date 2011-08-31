{ cabal, asn1Data, attoparsec, attoparsecEnumerator
, base64Bytestring, blazeBuilder, blazeBuilderEnumerator
, caseInsensitive, certificate, cprngAes, enumerator, failure
, httpTypes, monadControl, network, tls, tlsExtra, transformers
, utf8String, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-enumerator";
  version = "0.6.7";
  sha256 = "13x8p0dfaq2nkqh9ym7rbslnacvmdf5v1lpny2cia2im09hd1xbi";
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
    description = "HTTP client package with enumerator interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
