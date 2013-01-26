{ cabal, hashable, transformers, unorderedContainers, vault }:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.7.1.1";
  sha256 = "0d4dqpzglzkygy2hhn1j1c7vk2782mk66f8aqaadkyhijn7kc6i5";
  buildDepends = [ hashable transformers unorderedContainers vault ];
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
