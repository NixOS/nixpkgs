{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, failure, httpTypes
, liftedBase, monadControl, network, regexCompat, socks, text, time
, tls, tlsExtra, transformers, transformersBase, utf8String
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.2.5";
  sha256 = "0mb85akb7mgdhjkmp041lhqir2gys9bjixn2v1i848mijw1zx8zr";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault failure httpTypes liftedBase monadControl
    network regexCompat socks text time tls tlsExtra transformers
    transformersBase utf8String zlibConduit
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
