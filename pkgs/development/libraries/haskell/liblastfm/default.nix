{ cabal, aeson, attoparsec, cereal, cryptoApi, httpConduit
, httpTypes, HUnit, network, pureMD5, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.1.1.1";
  sha256 = "1svqxi85n18r9szmlcny51j71zzkki9pnfxnxim78y5vh0nf82qv";
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
