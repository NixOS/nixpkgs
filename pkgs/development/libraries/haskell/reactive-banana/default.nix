{ cabal, fclabels, hashable, QuickCheck, transformers
, unorderedContainers, vault
}:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.5.0.0";
  sha256 = "1dabyzdkc8imm397cj7i18r3784233a45jlli3y6ch8zg2kl1iri";
  buildDepends = [
    fclabels hashable QuickCheck transformers unorderedContainers vault
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Practical library for functional reactive programming (FRP)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.bluescreen303 ];
  };
})
