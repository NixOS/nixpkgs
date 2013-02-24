{ cabal, basicPrelude, hashable, hspec, liftedBase, QuickCheck
, systemFilepath, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.1";
  sha256 = "0kgnffqvh13adadp85iw4ybbs5jpa5hwrr2dsi2aj9p8lvzac1jy";
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
