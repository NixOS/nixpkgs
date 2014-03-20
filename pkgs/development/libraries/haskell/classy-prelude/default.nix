{ cabal, basicPrelude, chunkedData, enclosedExceptions, hashable
, hspec, liftedBase, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.8.1";
  sha256 = "04rgsw656vjzaibargw5ibzagy74mlsd25wpw6hn1phz8qkgls4l";
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
