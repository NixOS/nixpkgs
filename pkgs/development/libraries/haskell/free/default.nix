{ cabal, bifunctors, comonad, distributive, mtl, profunctors
, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.4";
  sha256 = "19c6zy7gxsd121g1kny9y8rv33gsxv3kfsi37iyn6q0p8r38wbcy";
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
