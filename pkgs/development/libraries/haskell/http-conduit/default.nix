{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cprngAes, dataDefault, failure, httpTypes, liftedBase
, monadControl, network, text, tls, tlsExtra, transformers
, transformersBase, utf8String, zlibConduit, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.0.0.1";
  sha256 = "0yag65ariakvbvsrr3kd16bags4caw8n3qlcwpzrblprgjrv06vm";
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
