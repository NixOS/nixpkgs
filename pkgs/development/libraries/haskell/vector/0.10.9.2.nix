{ cabal, deepseq, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.10.9.2";
  sha256 = "046w4w5dr5136smfxzhzkhzcx6jgpnqrc2x5lzy4vrlxhb8za6c1";
  buildDepends = [ deepseq primitive ];
  meta = {
    homepage = "https://github.com/haskell/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
