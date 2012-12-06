{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, parallel, semigroups, split, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.6.0.3";
  sha256 = "1zdgfqy0ag5h997a54006g6v6z87a2r342apf670q8p10rbrc1bq";
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
