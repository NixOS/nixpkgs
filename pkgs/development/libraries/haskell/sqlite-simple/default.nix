{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, directSqlite, HUnit, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "sqlite-simple";
  version = "0.4.5.1";
  sha256 = "0mmj6vk3yjvrbsggc5pyba5iprzvfhlsq1jfradpazgfc998j0ry";
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
