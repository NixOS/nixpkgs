{ cabal, Boolean, MemoTrie }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.7.6";
  sha256 = "166493dnlgrm9bsyp8dvdnkz1s5503casamihs4d3rij4fqvw7vf";
  buildDepends = [ Boolean MemoTrie ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/vector-space";
    description = "Vector & affine spaces, linear maps, and derivatives (requires ghc 6.9 or better)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
