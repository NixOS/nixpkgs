{ cabal, mysqlConfig, zlib }:

cabal.mkDerivation (self: {
  pname = "mysql";
  version = "0.1.1.6";
  sha256 = "1sxzx5f4ysxhq1nimkj4xwf87i7prwp5wg0kjbhv9pbn65zc9mmj";
  buildTools = [ mysqlConfig ];
  extraLibraries = [ zlib ];
  meta = {
    homepage = "https://github.com/bos/mysql";
    description = "A low-level MySQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
