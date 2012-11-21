{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, parallel, semigroups, split, text, transformers
, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.3";
  sha256 = "0gq24y1727ml5lpr0b67hqw3vwanvx6hpk3lsfx3nk6csscn1lvk";
  buildDepends = [
    comonad comonadsFd comonadTransformers filepath hashable mtl
    parallel semigroups split text transformers unorderedContainers
    vector void
  ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
