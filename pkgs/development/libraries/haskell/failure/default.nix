{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.2.0.3";
  sha256 = "0jimc2x46zq7wnmzfbnqi67jl8yhbvr0fa65ljlc9p3fns9mca3p";
  buildDepends = [ transformers ];
  jailbreak = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
