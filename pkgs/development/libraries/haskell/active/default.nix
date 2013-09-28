{ cabal, newtype, QuickCheck, semigroupoids, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.7";
  sha256 = "18pcw98ni8fiy0yd7wmrqvpaf2wgav70rsikqfl571zjmdmzdw7p";
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
