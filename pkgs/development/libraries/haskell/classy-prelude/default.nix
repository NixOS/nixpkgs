{ cabal, basicPrelude, hashable, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.0.1";
  sha256 = "1j55kfh39fd4vhn435679761hmpqcf023b9xhg8sab7spxyyvl4w";
  buildDepends = [
    basicPrelude hashable systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
