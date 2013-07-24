{ cabal, blazeBuilder, dateCache, filepath, hspec, text, unixTime
}:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.3.2";
  sha256 = "0bx8yjg7bf18i7j7fnhidnms5a3v6hiwqqvr249fk03c86v20rla";
  buildDepends = [ blazeBuilder dateCache filepath text unixTime ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
