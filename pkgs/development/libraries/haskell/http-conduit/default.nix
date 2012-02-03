{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cprngAes, dataDefault, failure, httpTypes, liftedBase
, monadControl, network, socks, text, time, tls, tlsExtra
, transformers, transformersBase, utf8String, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.2.3";
  sha256 = "0kygmbcvv0j020ml9jgmg3yzda3k066s2h8g3c135cmad6jc8hnd";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cprngAes
    dataDefault failure httpTypes liftedBase monadControl network socks
    text time tls tlsExtra transformers transformersBase utf8String
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
