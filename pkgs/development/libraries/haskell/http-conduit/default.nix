{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cprngAes, dataDefault, failure, httpTypes, liftedBase
, monadControl, network, text, tls, tlsExtra, transformers
, transformersBase, utf8String, zlibConduit, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.0.0";
  sha256 = "1ix2qx6zqp8g7hjg2ygwivzg4hhz2ac22rbybh9adzvzw0q2yvgk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cprngAes
    dataDefault failure httpTypes liftedBase monadControl network text
    tls tlsExtra transformers transformersBase utf8String zlibConduit
    zlibEnum
  ];
  meta = {
    homepage = "http://github.com/snoyberg/http-enumerator";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
