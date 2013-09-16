{ cabal, async, basicPrelude, deepseq, hashable, hspec, liftedBase
, monadControl, QuickCheck, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.10";
  sha256 = "04grmld90qr8m6lcdf83clai0anpp8iry7m9l9li8ija9fckl3lk";
  buildDepends = [
    async basicPrelude deepseq hashable liftedBase monadControl
    systemFilepath text transformers unorderedContainers vector
  ];
  testDepends = [ hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
