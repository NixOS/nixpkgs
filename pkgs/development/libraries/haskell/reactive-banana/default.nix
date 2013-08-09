{ cabal, hashable, HUnit, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.7.1.3";
  sha256 = "117y1sk97kpiq0cippq0ydl2zqb99q49y2m2m6pgg2nh6gz6a3zb";
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
