{ cabal, asn1Data, attoparsec, attoparsecConduit, base64Bytestring
, blazeBuilder, blazeBuilderConduit, caseInsensitive, certificate
, conduit, cookie, cprngAes, dataDefault, deepseq, failure
, filepath, httpTypes, liftedBase, mimeTypes, monadControl, mtl
, network, random, regexCompat, resourcet, socks, text, time, tls
, tlsExtra, transformers, transformersBase, utf8String, void
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "1.8.7";
  sha256 = "12v5rxp4dx6glyijygpp7r7b5b6mscclgfp2cbii78m3hgld097i";
  buildDepends = [
    asn1Data attoparsec attoparsecConduit base64Bytestring blazeBuilder
    blazeBuilderConduit caseInsensitive certificate conduit cookie
    cprngAes dataDefault deepseq failure filepath httpTypes liftedBase
    mimeTypes monadControl mtl network random regexCompat resourcet
    socks text time tls tlsExtra transformers transformersBase
    utf8String void zlibConduit
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
