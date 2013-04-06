{ cabal, cereal, cryptoApi, HUnit, QuickCheck, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.9.0";
  sha256 = "0ipzrp83pz33qc7gmn9bmhbmc1f0hfvagyfr5bnmhgrh6lgy9s7l";
  buildDepends = [ cereal cryptoApi tagged ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
