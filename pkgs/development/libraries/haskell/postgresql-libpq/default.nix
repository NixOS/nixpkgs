{ cabal, postgresql }:

cabal.mkDerivation (self: {
  pname = "postgresql-libpq";
  version = "0.8.2.3";
  sha256 = "08l3va5v8ppajgl8ywmzjdvd6v2vhqfj0y55mb1jxkdpvkd5hckl";
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://github.com/lpsmith/postgresql-libpq";
    description = "low-level binding to libpq";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
