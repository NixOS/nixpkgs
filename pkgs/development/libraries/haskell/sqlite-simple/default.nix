{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, directSqlite, HUnit, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "sqlite-simple";
  version = "0.4.5.2";
  sha256 = "04080ak589n0abisb6bzsmycrh3l8sh0ipcl1gcsvvfd4x83c9yi";
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
