{ cabal, bifunctors, comonad, distributive, mtl, profunctors
, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.2";
  sha256 = "0g2k36xqma8r6shrih40w5xv0pgs5ldr9lhc5hjpwmh4n3hgdhfb";
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
