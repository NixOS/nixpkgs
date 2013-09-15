{ cabal, postgresql }:

cabal.mkDerivation (self: {
  pname = "postgresql-libpq";
  version = "0.8.2.4";
  sha256 = "1dqb4pnsvd6378rhmlhi151sin06wfm9sx12m3ir9x0j5ppb5sx6";
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://github.com/lpsmith/postgresql-libpq";
    description = "low-level binding to libpq";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
