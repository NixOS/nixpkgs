{ cabal, basicPrelude, chunkedData, enclosedExceptions, exceptions
, hashable, hspec, liftedBase, monoTraversable, QuickCheck
, semigroups, stm, systemFilepath, text, time, transformers
, unorderedContainers, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.9.2";
  sha256 = "0n006ld2kifh2bmwgbzx282s7xxpcml9g433x132prcblw4axkgr";
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
