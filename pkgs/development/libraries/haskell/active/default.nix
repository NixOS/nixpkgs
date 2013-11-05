{ cabal, newtype, QuickCheck, semigroupoids, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.9";
  sha256 = "0639qp4yc3dfvc9xcjk9k7qagvbcjwdgz3lklqsak9h551ccl7bv";
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
