{ cabal, basicPrelude, chunkedData, enclosedExceptions, exceptions
, hashable, hspec, liftedBase, monoTraversable, QuickCheck
, semigroups, stm, systemFilepath, text, time, transformers
, unorderedContainers, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.9.1";
  sha256 = "08rcfgr2mjgjvacmyih693pvq9jwfj9nshkazw8x6wlzlwr56ag8";
  buildDepends = [
    basicPrelude chunkedData enclosedExceptions exceptions hashable
    liftedBase monoTraversable semigroups stm systemFilepath text time
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
