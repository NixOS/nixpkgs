{ cabal, base16Bytestring, directSqlite, HUnit, text, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "sqlite-simple";
  version = "0.4.4.0";
  sha256 = "09vgy3hji0bjb3bwxwkwhmgf50q442dqr3d86g5l5s3xiw3hca0r";
  buildDepends = [ directSqlite text time transformers ];
  testDepends = [ base16Bytestring directSqlite HUnit text time ];
  meta = {
    homepage = "http://github.com/nurpax/sqlite-simple";
    description = "Mid-Level SQLite client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
