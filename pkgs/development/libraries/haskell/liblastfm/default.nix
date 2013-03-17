{ cabal, aeson, cereal, cryptoApi, httpConduit, httpTypes, network
, pureMD5, text
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.1.1.0";
  sha256 = "1yrgyb0m1gdhsrkv3b8a5a0qii67v9gx1kbv79ixlac60bsm4q95";
  buildDepends = [
    aeson cereal cryptoApi httpConduit httpTypes network pureMD5 text
  ];
  meta = {
    description = "Lastfm API interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
