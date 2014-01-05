{ cabal, postgresql }:

cabal.mkDerivation (self: {
  pname = "postgresql-libpq";
  version = "0.8.2.6";
  sha256 = "0n3lqffscwc6pq0rfy4yjild9hcgnkpq9a8icbvgxv4si13ipsgh";
  extraLibraries = [ postgresql ];
  meta = {
    homepage = "http://github.com/lpsmith/postgresql-libpq";
    description = "low-level binding to libpq";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
