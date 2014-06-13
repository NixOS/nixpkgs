{ cabal, deepseq, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.10.11.0";
  sha256 = "0f5jks8q0287zgzlfg3x7akpahck6dm1c37hb8kk6qn51csx515j";
  buildDepends = [ deepseq primitive ];
  meta = {
    homepage = "https://github.com/haskell/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
