{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cprngAes, dataDefault, failure, httpTypes, liftedBase
, monadControl, network, text, tls, tlsExtra, transformers
, transformersBase, utf8String, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.1.0.1";
  sha256 = "0jlj727rs8f1yxy6ms2gi3ryj4di5la0pgn2hw5flglflacj8wb6";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cprngAes
    dataDefault failure httpTypes liftedBase monadControl network text
    tls tlsExtra transformers transformersBase utf8String zlibConduit
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
