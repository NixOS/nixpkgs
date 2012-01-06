{ cabal, asn1Data, attoparsec, attoparsecEnumerator
, base64Bytestring, blazeBuilder, blazeBuilderEnumerator
, caseInsensitive, certificate, cprngAes, dataDefault, enumerator
, failure, httpTypes, monadControl, network, tls, tlsExtra
, transformers, utf8String, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-enumerator";
  version = "0.7.2.2";
  sha256 = "0s0mjws2sgpbydx4cv9waz71lpylgbbyk0wmvypyjvfhxd9d01hf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data attoparsec attoparsecEnumerator base64Bytestring
    blazeBuilder blazeBuilderEnumerator caseInsensitive certificate
    cprngAes dataDefault enumerator failure httpTypes monadControl
    network tls tlsExtra transformers utf8String zlibEnum
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
