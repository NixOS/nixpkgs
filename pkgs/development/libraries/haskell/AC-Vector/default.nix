{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "AC-Vector";
  version = "2.3.2";
  sha256 = "04ahf6ldfhvzbml9xd6yplygn8ih7b8zz7cw03hkr053g5kzylay";
  buildDepends = [ Cabal ];
  meta = {
    description = "Efficient geometric vectors and transformations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
