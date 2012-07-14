{ cabal, fclabels, hashable, QuickCheck, transformers
, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.6.0.0";
  sha256 = "1s0ymkqrjnzylxdwqfslf87g7sjqk135hnvgdkzy4dbvvpplq113";
  buildDepends = [
    fclabels hashable QuickCheck transformers unorderedContainers vault
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
