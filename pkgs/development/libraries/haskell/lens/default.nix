{ cabal, bifunctors, comonad, comonadsFd, comonadTransformers
, contravariant, distributive, filepath, genericDeriving, hashable
, MonadCatchIOTransformers, mtl, parallel, profunctorExtras
, profunctors, reflection, semigroupoids, semigroups, split, tagged
, text, transformers, transformersCompat, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.8.5";
  sha256 = "09z2izh7mqj75yh9f0pb8ky9vnzs9zx2z2mz1ik7l8wid43gm6vn";
  buildDepends = [
    bifunctors comonad comonadsFd comonadTransformers contravariant
    distributive filepath genericDeriving hashable
    MonadCatchIOTransformers mtl parallel profunctorExtras profunctors
    reflection semigroupoids semigroups split tagged text transformers
    transformersCompat unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
