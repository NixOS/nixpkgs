{ cabal, blazeBuilder, caseInsensitive, conduit, conduitExtra
, connection, cookie, dataDefaultClass, hspec, httpClient
, httpClientTls, httpTypes, HUnit, liftedBase, monadControl, mtl
, network, networkConduit, resourcet, streamingCommons, text, time
, transformers, utf8String, wai, waiConduit, warp, warpTls
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "2.1.2.3";
  sha256 = "07d9lhkqf1kr4mg61q0pcf8y73wkdymazxrvr425wjh9363r89gl";
  buildDepends = [
    conduit httpClient httpClientTls httpTypes liftedBase monadControl
    mtl resourcet transformers
  ];
  testDepends = [
    blazeBuilder caseInsensitive conduit conduitExtra connection cookie
    dataDefaultClass hspec httpClient httpTypes HUnit liftedBase
    network networkConduit streamingCommons text time transformers
    utf8String wai waiConduit warp warpTls
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
