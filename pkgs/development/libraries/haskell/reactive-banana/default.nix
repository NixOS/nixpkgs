{ cabal, hashable, QuickCheck, transformers, unorderedContainers
, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.7.0.1";
  sha256 = "0nd6j2782x7i12xw480qgk42jkya9qi0xdas15ik6cmg4c9z1dyk";
  buildDepends = [
    hashable QuickCheck transformers unorderedContainers vault
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
