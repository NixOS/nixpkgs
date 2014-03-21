{ cabal, exceptions, extensibleExceptions, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-mtl";
  version = "1.1.0.0";
  sha256 = "1vmiy00fsdp1jzmpjrz8wzxbv3185h27aspw412pmcr4v1n29kxc";
  buildDepends = [ exceptions extensibleExceptions mtl ];
  meta = {
    homepage = "http://hub.darcs.net/jcpetruzza/ghc-mtl";
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
