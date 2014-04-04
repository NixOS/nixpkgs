{ cabal, basicPrelude, chunkedData, enclosedExceptions, hashable
, hspec, liftedBase, monoTraversable, QuickCheck, semigroups, stm
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.8.3.1";
  sha256 = "1mszblcww2pqy1zybib7rd4y6sqbd5nih0zzfi9zb69bwwb7mjai";
  buildDepends = [
    basicPrelude chunkedData enclosedExceptions hashable liftedBase
    monoTraversable semigroups stm systemFilepath text time
    transformers unorderedContainers vector vectorInstances
  ];
  testDepends = [
    hspec QuickCheck transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
