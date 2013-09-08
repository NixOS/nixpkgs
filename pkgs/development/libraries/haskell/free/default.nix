{ cabal, bifunctors, comonad, comonadsFd, comonadTransformers
, distributive, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "3.4.1";
  sha256 = "09yfkmnmhwwq22fsm1f4li4h13c3bqnh274z8jpgw0hrcnssh0rk";
  buildDepends = [
    bifunctors comonad comonadsFd comonadTransformers distributive mtl
    semigroupoids semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/free/";
    description = "Monads for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
