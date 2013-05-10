{ cabal, basicPrelude, hashable, hspec, liftedBase, QuickCheck
, systemFilepath, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.4";
  sha256 = "1p30f1inp0kj2dsvqnxaplxl83kd8bv41jmszvbdbf3vijjpk6kr";
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
