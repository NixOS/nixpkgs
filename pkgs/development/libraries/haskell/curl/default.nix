{ cabal, curl }:

cabal.mkDerivation (self: {
  pname = "curl";
  version = "1.3.8";
  sha256 = "0vj4hpaa30jz7c702xpsfvqaqdxz28zslsqnsfx6bf6dpwvck1wh";
  extraLibraries = [ curl ];
  meta = {
    description = "Haskell binding to libcurl";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
