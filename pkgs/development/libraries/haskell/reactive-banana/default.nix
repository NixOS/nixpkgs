{ cabal, hashable, HUnit, pqueue, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.8.0.2";
  sha256 = "0hfhq663dvvb3jbgdnarawryw09m8ckqvqp6p5n4d4dms4gfzcdv";
  buildDepends = [
    hashable pqueue transformers unorderedContainers vault
  ];
  testDepends = [
    hashable HUnit pqueue testFramework testFrameworkHunit transformers
    unorderedContainers vault
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Library for functional reactive programming (FRP)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
