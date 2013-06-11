{ cabal, basicPrelude, hashable, hspec, liftedBase, monadControl
, QuickCheck, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.8";
  sha256 = "1yq2x3mfkasprmsx1gracjhih9l9x0dsq6pdf90khlcl11qh57ir";
  buildDepends = [
    basicPrelude hashable liftedBase monadControl systemFilepath text
    transformers unorderedContainers vector
  ];
  testDepends = [ hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
