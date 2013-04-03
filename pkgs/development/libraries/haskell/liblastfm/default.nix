{ cabal, aeson, attoparsec, cereal, cryptoApi, httpConduit
, httpTypes, HUnit, network, pureMD5, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.1.1.2";
  sha256 = "1zckgjc0r2s1s6s9s309dr2ri8bzj1fi8gcbhm3hifczq1v149w9";
  buildDepends = [
    aeson cereal cryptoApi httpConduit httpTypes network pureMD5 text
  ];
  testDepends = [
    aeson attoparsec HUnit testFramework testFrameworkHunit text
  ];
  meta = {
    description = "Lastfm API interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
