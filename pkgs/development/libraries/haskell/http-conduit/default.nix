{ cabal, blazeBuilder, caseInsensitive, conduit, connection, cookie
, dataDefaultClass, hspec, httpClient, httpClientConduit
, httpClientMultipart, httpClientTls, httpTypes, HUnit, liftedBase
, network, networkConduit, resourcet, text, time, transformers
, utf8String, wai, warp, warpTls
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "2.0.0.8";
  sha256 = "1yralv1nalvdpgamnbjl8xm4lrx22m3v6jancrzisq38a680q96b";
  buildDepends = [
    conduit httpClient httpClientConduit httpClientTls httpTypes
    liftedBase resourcet transformers
  ];
  testDepends = [
    blazeBuilder caseInsensitive conduit connection cookie
    dataDefaultClass hspec httpClient httpClientMultipart httpTypes
    HUnit liftedBase network networkConduit text time transformers
    utf8String wai warp warpTls
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
