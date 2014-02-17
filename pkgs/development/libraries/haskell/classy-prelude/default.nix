{ cabal, basicPrelude, chunkedData, enclosedExceptions, hashable
, hspec, liftedBase, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.8.0";
  sha256 = "02zf6v7a6bjf9z391bravx10mw0w4m4p5b78zap08z2i6fk5h91g";
  buildDepends = [
    basicPrelude chunkedData enclosedExceptions hashable liftedBase
    monoTraversable semigroups systemFilepath text time transformers
    unorderedContainers vector vectorInstances
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
