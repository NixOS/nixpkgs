{ cabal, hashable, HUnit, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.7.1.2";
  sha256 = "1x4ln3dr937va0ii7lr86d6wsrh2qd1sxany4y9dkpcrsvb3db0l";
  buildDepends = [ hashable transformers unorderedContainers vault ];
  testDepends = [
    hashable HUnit testFramework testFrameworkHunit transformers
    unorderedContainers vault
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Practical library for functional reactive programming (FRP)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
