{ cabal, bifunctors, comonad, comonadsFd, comonadTransformers
, contravariant, distributive, filepath, genericDeriving, hashable
, MonadCatchIOTransformers, mtl, parallel, profunctorExtras
, profunctors, reflection, semigroupoids, semigroups, split, tagged
, text, transformers, transformersCompat, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.8.2";
  sha256 = "1spz4nyv1f7kf4bnw8qgqaks5kc4m0slzw0czj1wh1232w2sz15m";
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
