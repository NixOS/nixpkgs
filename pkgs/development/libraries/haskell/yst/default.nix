{ cabal, csv, filepath, HDBC, HDBCSqlite3, HsSyck, HStringTemplate
, pandoc, parsec, split, time, utf8String, xhtml
}:

cabal.mkDerivation (self: {
  pname = "yst";
  version = "0.3";
  sha256 = "1f09qcf2kqgq9w7irvzlwhv5sy0q3ml82ksza72hj0f5rfbyvfla";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    csv filepath HDBC HDBCSqlite3 HsSyck HStringTemplate pandoc parsec
    split time utf8String xhtml
  ];
  meta = {
    homepage = "http://github.com/jgm/yst";
    description = "Builds a static website from templates and data in YAML or CSV files";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
