{ cabal, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.0";
  sha256 = "f323b4b486523a1778841c1c5d0917a1dfd7dca68298dc8a022341efcb3a83f4";
  buildDepends = [ hashable text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
