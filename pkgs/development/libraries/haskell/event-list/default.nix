{ cabal, nonNegative, QuickCheck, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "event-list";
  version = "0.1.1";
  sha256 = "1qv7a4np8cr0chbvlz0kmcrvc95w1z7fqs2pq0mkwx22hnslsh5l";
  buildDepends = [ nonNegative QuickCheck transformers utilityHt ];
  testDepends = [
    nonNegative QuickCheck random transformers utilityHt
  ];
  meta = {
    homepage = "http://code.haskell.org/~thielema/event-list/";
    description = "Event lists with relative or absolute time stamps";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
