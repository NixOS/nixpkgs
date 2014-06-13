{ cabal, chell, chellQuickcheck, deepseq, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.12";
  sha256 = "0sfralwgd5b9hfqmp20v31sq96s0v7j9g920qdj3n9i5mhslhwd2";
  buildDepends = [ deepseq text ];
  testDepends = [ chell chellQuickcheck QuickCheck text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
