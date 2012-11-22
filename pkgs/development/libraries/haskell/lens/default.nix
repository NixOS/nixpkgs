{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, parallel, semigroups, split, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.4";
  sha256 = "19f5kmd6b1jnimvfm56dpgqzhnlpi0anar1ii9am38lg5yaqbgs4";
  buildDepends = [
    comonad comonadsFd comonadTransformers filepath hashable mtl
    parallel semigroups split text transformers unorderedContainers
    vector
  ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
