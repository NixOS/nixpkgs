{ cabal, doctest, filepath, QuickCheck, text, thLift, vector }:

cabal.mkDerivation (self: {
  pname = "th-lift-instances";
  version = "0.1.2";
  sha256 = "0xfz7jnhqxqxd6ijn6vpd0nay38kj862ylsb71xqi35137g5zl9w";
  buildDepends = [ text thLift vector ];
  testDepends = [ doctest filepath QuickCheck text vector ];
  meta = {
    homepage = "http://github.com/bennofs/th-lift-instances/";
    description = "Lift instances for template-haskell for common data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
