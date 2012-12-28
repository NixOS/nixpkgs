{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, parallel, semigroups, split, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.7.1.2";
  sha256 = "1hapcnmyqyc3645gsy1ikwzm2srbbznps6yrfr02y2lcbnjpn3g6";
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
