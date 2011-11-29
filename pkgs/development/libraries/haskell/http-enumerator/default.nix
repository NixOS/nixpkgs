{ cabal, asn1Data, attoparsec, attoparsecEnumerator
, base64Bytestring, blazeBuilder, blazeBuilderEnumerator
, caseInsensitive, certificate, cprngAes, dataDefault, enumerator
, failure, httpTypes, monadControl, network, tls, tlsExtra
, transformers, utf8String, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-enumerator";
  version = "0.7.1.6";
  sha256 = "0jkjysg89i5fajnmxpg0x5swgvz80ms00j6awd8dsn3mrsaw9x34";
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
