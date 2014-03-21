{ cabal, basicPrelude, chunkedData, enclosedExceptions, hashable
, hspec, liftedBase, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.8.1.1";
  sha256 = "14iq0zdmw4f2i3c282hs89c4a763wcm7vn5n0f6kcvcpjgjyahgi";
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
