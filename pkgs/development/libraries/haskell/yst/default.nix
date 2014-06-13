{ cabal, aeson, csv, filepath, HDBC, HDBCSqlite3, HStringTemplate
, pandoc, parsec, scientific, split, text, time
, unorderedContainers, xhtml, yaml
}:

cabal.mkDerivation (self: {
  pname = "yst";
  version = "0.4.1";
  sha256 = "199awgpxn9131a7ijxvvbc4mi1yasnllbpj77k27brx00j87v3nq";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson csv filepath HDBC HDBCSqlite3 HStringTemplate pandoc parsec
    scientific split text time unorderedContainers xhtml yaml
  ];
  meta = {
    homepage = "http://github.com/jgm/yst";
    description = "Builds a static website from templates and data in YAML or CSV files";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
