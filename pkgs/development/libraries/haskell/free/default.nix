{ cabal, bifunctors, comonad, distributive, mtl, profunctors
, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.6.1";
  sha256 = "0xmnxp6x7b6pp2ap7jrjhz00cm30v334i9dcxc14d3r070h7l73w";
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
