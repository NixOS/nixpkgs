{ cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.1.0";
  sha256 = "1843fddsc7x3mf6h69xpg7yjkpaws4v57zg02424mj86m5x6jfgz";
  meta = {
    description = "Generalized booleans";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
