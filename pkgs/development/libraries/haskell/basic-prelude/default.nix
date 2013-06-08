{ cabal, hashable, liftedBase, ReadArgs, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.5.0";
  sha256 = "1nrfibvvh5vzzr2jz5hipsj29b7ml6d90ijlr917n9aq200w14ar";
  buildDepends = [
    hashable liftedBase ReadArgs systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/basic-prelude";
    description = "An enhanced core prelude; a common foundation for alternate preludes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
