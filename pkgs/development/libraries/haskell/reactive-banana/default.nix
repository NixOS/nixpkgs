{ cabal, fclabels, hashable, QuickCheck, transformers
, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.5.0.2";
  sha256 = "10391b6vwgp5harzmiji66qs4zc5qipagak1mm2j8njhbqi8z0rb";
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
