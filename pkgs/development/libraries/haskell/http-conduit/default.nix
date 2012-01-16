{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cprngAes, dataDefault, failure, httpTypes, liftedBase
, monadControl, network, text, time, tls, tlsExtra, transformers
, transformersBase, utf8String, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.1.1";
  sha256 = "0gqx871d86m00aqmldqnd9nxf5zvlqpsaprsgx9zvipb270rrwsi";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cprngAes
    dataDefault failure httpTypes liftedBase monadControl network text
    time tls tlsExtra transformers transformersBase utf8String
    zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
