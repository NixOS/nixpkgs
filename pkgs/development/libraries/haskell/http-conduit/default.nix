{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, failure, httpTypes
, liftedBase, monadControl, mtl, network, regexCompat, socks, text
, time, tls, tlsExtra, transformers, transformersBase, utf8String
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.2.6";
  sha256 = "0gspqkydw5v4wb9s0ipy5s708nmqp3phkh3j95mzn6nlbk2r9kvn";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault failure httpTypes liftedBase monadControl mtl
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
