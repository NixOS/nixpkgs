{ cabal, basicPrelude, hashable, hspec, liftedBase, QuickCheck
, systemFilepath, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.2";
  sha256 = "1nmhx6fs783v67b5ygdlmpxbsj41brj32i1sx9gyjyhfvr40wiw5";
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
