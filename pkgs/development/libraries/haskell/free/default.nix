{ cabal, bifunctors, comonad, distributive, mtl, profunctors
, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.0";
  sha256 = "0hcswwd3qc9mjxhvrsc4sxgixgh2j6n6rnhrm2s06czh94v9hm1i";
  buildDepends = [
    bifunctors comonad distributive mtl profunctors semigroupoids
    semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/free/";
    description = "Monads for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
