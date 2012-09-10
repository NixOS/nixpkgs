{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "logict";
  version = "0.5.0.2";
  sha256 = "0m0a55l061vbxdqw9h1780g893amdxs7glza4jd5jncjsv823s1z";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/logict";
    description = "A backtracking logic-programming monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
