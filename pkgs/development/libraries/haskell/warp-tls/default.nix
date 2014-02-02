{ cabal, conduit, cprngAes, dataDefaultClass, network
, networkConduit, tls, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.2";
  sha256 = "02wj9hwxd0x49g7kl68h3r4b9hc29yqfjagyybnr42xzwl6bdpyg";
  buildDepends = [
    conduit cprngAes dataDefaultClass network networkConduit tls
    transformers wai warp
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "HTTP over SSL/TLS support for Warp via the TLS package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
