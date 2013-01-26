{ cabal, csv, filepath, HDBC, HDBCSqlite3, HsSyck, HStringTemplate
, pandoc, parsec, split, time, utf8String, xhtml
}:

cabal.mkDerivation (self: {
  pname = "yst";
  version = "0.3.1";
  sha256 = "1ax3j21b4ac9x4vvvfgnhz0sczd7l7ia6mcxnqhbc3166sn91vig";
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
