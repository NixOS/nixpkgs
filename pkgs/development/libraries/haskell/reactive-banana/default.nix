{ cabal, hashable, HUnit, pqueue, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.8.0.0";
  sha256 = "15dzvn7cbs9kg410lyd1kj6kf2r7ap2n9bc59byzkb0r8wzn9ra1";
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
