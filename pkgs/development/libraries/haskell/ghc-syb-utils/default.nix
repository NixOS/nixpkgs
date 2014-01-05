{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "ghc-syb-utils";
  version = "0.2.1.2";
  sha256 = "12k6a782gv06gmi6dvskzv4ihz54izhqslwa9cgilhsihw557i9p";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://github.com/nominolo/ghc-syb";
    description = "Scrap Your Boilerplate utilities for the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
