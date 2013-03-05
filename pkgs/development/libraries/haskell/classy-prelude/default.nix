{ cabal, basicPrelude, hashable, hspec, liftedBase, QuickCheck
, systemFilepath, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.3";
  sha256 = "0xlhdxkxvrzj9y8wdl2f1pz94zz2gfa9vfbia9prhr7skirxvsad";
  buildDepends = [
    basicPrelude hashable liftedBase systemFilepath text transformers
    unorderedContainers vector
  ];
  testDepends = [ hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
