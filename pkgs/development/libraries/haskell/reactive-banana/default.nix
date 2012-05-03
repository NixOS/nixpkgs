{ cabal, fclabels, hashable, QuickCheck, transformers
, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.5.0.3";
  sha256 = "0j60g7k0xrq66m8g8fd9fdrpbnz2jbgqxnmbz1rfi5bvnrkhv10v";
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
