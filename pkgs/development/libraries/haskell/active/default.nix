{ cabal, newtype, QuickCheck, semigroupoids, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.14";
  sha256 = "0ibigflx3krmf7gw0zqmqx73rw1p62cwjyl26rxbj5vzbl3bdb4g";
  buildDepends = [ newtype semigroupoids semigroups vectorSpace ];
  testDepends = [
    newtype QuickCheck semigroupoids semigroups vectorSpace
  ];
  jailbreak = true;
  meta = {
    description = "Abstractions for animation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
