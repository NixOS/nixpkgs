{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, directSqlite, HUnit, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "sqlite-simple";
  version = "0.4.7.0";
  sha256 = "128b8n66j729g9mwndv5m3plww6av7hin7dmwsbs19v8klcaf4f5";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual directSqlite text time
    transformers
  ];
  testDepends = [ base16Bytestring directSqlite HUnit text time ];
  meta = {
    homepage = "http://github.com/nurpax/sqlite-simple";
    description = "Mid-Level SQLite client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
