{ cabal, Cabal, liftedBase, monadControl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "alternative-io";
  version = "0.0.0";
  sha256 = "1nfwiw753m8ljrk47yi5cgncbfkddnr4fz44fk1pv501a86cmk8y";
  buildDepends = [
    Cabal liftedBase monadControl transformers transformersBase
  ];
  meta = {
    description = "IO as Alternative instance";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
