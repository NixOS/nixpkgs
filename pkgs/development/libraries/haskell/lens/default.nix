{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, parallel, semigroups, split, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.6";
  sha256 = "1zl52hj0ccx21qwlqrscfjmc7i0g2prikmd3lgbfbgjqlh7wnqdq";
  buildDepends = [
    comonad comonadsFd comonadTransformers filepath hashable mtl
    parallel semigroups split text transformers unorderedContainers
    vector
  ];
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
