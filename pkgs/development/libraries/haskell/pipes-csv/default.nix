{ cabal, blazeBuilder, cassava, HUnit, pipes, pipesBytestring
, testFramework, testFrameworkHunit, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "pipes-csv";
  version = "1.4.0";
  sha256 = "1q1gnfnkvlkk8lwllhyar7323k3jynh9rl6x9yks7lc3nqr1n16j";
  buildDepends = [
    blazeBuilder cassava pipes unorderedContainers vector
  ];
  testDepends = [
    cassava HUnit pipes pipesBytestring testFramework
    testFrameworkHunit vector
  ];
  meta = {
    description = "Fast, streaming csv parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
