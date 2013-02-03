{ cabal, aeson, cereal, cryptoApi, httpConduit, httpTypes, network
, pureMD5, text
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.1.0.0";
  sha256 = "1777p2zysha9z389dkzvc22wph5k2xa6f23xk1ckr8j1q5v9dg6x";
  buildDepends = [
    aeson cereal cryptoApi httpConduit httpTypes network pureMD5 text
  ];
  meta = {
    description = "Lastfm API interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
