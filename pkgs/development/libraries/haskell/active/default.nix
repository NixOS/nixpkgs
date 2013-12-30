{ cabal, newtype, QuickCheck, semigroupoids, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.10";
  sha256 = "173ri9hv86sjfp3a0jp1y3v8rz0lfb6nz3yilcfvgc9sglcxa4bm";
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
