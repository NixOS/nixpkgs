{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, directSqlite, HUnit, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "sqlite-simple";
  version = "0.4.5.0";
  sha256 = "0y4w8rj46lawz3hbi8dz80fbvxxgzj85094dxkwvpzgrf33py4y4";
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
