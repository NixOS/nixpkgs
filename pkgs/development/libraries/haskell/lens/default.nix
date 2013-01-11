{ cabal, comonad, comonadsFd, comonadTransformers, filepath
, hashable, mtl, nats, parallel, semigroups, split, text
, transformers, transformersCompat, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.7.3";
  sha256 = "0mvwczviszfv52ylymvrz3zk6s05ngmqc2g1k4r6pym8s9cmgmzz";
  buildDepends = [
    comonad comonadsFd comonadTransformers filepath hashable mtl nats
    parallel semigroups split text transformers transformersCompat
    unorderedContainers vector
  ];
  patchPhase = ''
    sed -i -e 's|semigroups.*,|semigroups,|' lens.cabal
  '';
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
