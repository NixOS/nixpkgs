{ cabal, postgresql }:

cabal.mkDerivation (self: {
  pname = "postgresql-libpq";
  version = "0.9.0.0";
  sha256 = "09bi0npvly02zjhp463bmzm1n8w1cqsln676z82xi2in86317pv3";
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://github.com/lpsmith/postgresql-libpq";
    description = "low-level binding to libpq";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
