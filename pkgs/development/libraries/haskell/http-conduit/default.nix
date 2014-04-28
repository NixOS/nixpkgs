{ cabal, blazeBuilder, caseInsensitive, conduit, conduitExtra
, connection, cookie, dataDefaultClass, hspec, httpClient
, httpClientTls, httpTypes, HUnit, liftedBase, monadControl, mtl
, network, networkConduit, resourcet, streamingCommons, text, time
, transformers, utf8String, wai, warp, warpTls
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "2.1.2";
  sha256 = "11g79yfgm2fzcy7gwk9f5np4p6fknsbjkm858v8khb4a1gmbrqvn";
  buildDepends = [
    conduit httpClient httpClientTls httpTypes liftedBase monadControl
    mtl resourcet transformers
  ];
  testDepends = [
    blazeBuilder caseInsensitive conduit conduitExtra connection cookie
    dataDefaultClass hspec httpClient httpTypes HUnit liftedBase
    network networkConduit streamingCommons text time transformers
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
