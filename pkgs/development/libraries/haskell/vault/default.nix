{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.3.0.2";
  sha256 = "1m9vanwzlw61fbdcy7qvv2prmbax5y9dsl52dldcf5zr7vip2hpb";
  buildDepends = [ hashable unorderedContainers ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
