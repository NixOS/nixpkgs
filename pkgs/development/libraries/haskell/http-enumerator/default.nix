{ cabal, asn1Data, attoparsec, attoparsecEnumerator
, base64Bytestring, blazeBuilder, blazeBuilderEnumerator
, caseInsensitive, certificate, cprngAes, enumerator, failure
, httpTypes, monadControl, network, tls, tlsExtra, transformers
, utf8String, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-enumerator";
  version = "0.6.6";
  sha256 = "0bmrj0jhjvqpx2kgpy5sz6sx17cxbpv07975n1055vgyzv1lcx07";
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
