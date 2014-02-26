{ cabal, bifunctors, comonad, distributive, mtl, profunctors
, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.5";
  sha256 = "0hcdl02whmnyxd3mbfrncd978778irm5sx5f4z54zsigwlk822vx";
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
