{ cabal, bifunctors, comonad, comonadsFd, comonadTransformers
, distributive, mtl, profunctors, semigroupoids, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "3.4.2";
  sha256 = "1x6pdkcxk6z9ndph2yzz5n21afc2330m0ryv4w67jsss5aa69fwb";
  buildDepends = [
    bifunctors comonad comonadsFd comonadTransformers distributive mtl
    profunctors semigroupoids semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/free/";
    description = "Monads for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
