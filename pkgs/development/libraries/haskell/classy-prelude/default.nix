{ cabal, basicPrelude, hashable, hspec, liftedBase, monadControl
, QuickCheck, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.7";
  sha256 = "1wq8la7nq3dh21yqwcjhwgy5s5mpqlvmrfma48v8ch6w4wwb0sqz";
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
