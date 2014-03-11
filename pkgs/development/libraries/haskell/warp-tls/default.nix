{ cabal, conduit, cprngAes, dataDefaultClass, network
, networkConduit, tls, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.3.1";
  sha256 = "1cyf4syblisi5hana7h2g72yyrjln40v3b6jq2253nglqip79l5w";
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
