{ cabal, newtype, QuickCheck, semigroupoids, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.13";
  sha256 = "12ljr12xj1kpj5llxfyigwf6340m17bx56a6qmrn580fshic670z";
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
