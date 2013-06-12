{ cabal, aeson, attoparsec, cereal, contravariant, cryptoApi
, httpConduit, httpTypes, HUnit, network, pureMD5, testFramework
, testFrameworkHunit, text, void
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.2.0.0";
  sha256 = "1x147mry8pq8qzrhrsbxm4b7sb80c9900kq2igwvcskwszd5h56n";
  buildDepends = [
    aeson cereal contravariant cryptoApi httpConduit httpTypes network
    pureMD5 text void
  ];
  testDepends = [
    aeson attoparsec HUnit testFramework testFrameworkHunit text
  ];
  meta = {
    description = "Lastfm API interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
