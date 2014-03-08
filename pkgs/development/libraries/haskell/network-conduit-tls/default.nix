{ cabal, conduit, connection, cprngAes, dataDefault, HUnit
, monadControl, mtl, network, networkConduit, systemFileio
, systemFilepath, tls, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.4.2";
  sha256 = "1pgb6k6g10hy2k4sihj88n6w7400d4grja2crhhv1cydqdn858rc";
  buildDepends = [
    conduit connection cprngAes dataDefault monadControl network
    networkConduit systemFileio systemFilepath tls transformers
  ];
  testDepends = [ conduit connection HUnit mtl networkConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
