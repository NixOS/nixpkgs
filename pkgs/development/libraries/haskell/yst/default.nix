{ cabal, aeson, csv, filepath, HDBC, HDBCSqlite3, HStringTemplate
, pandoc, parsec, split, text, time, unorderedContainers, xhtml
, yaml
}:

cabal.mkDerivation (self: {
  pname = "yst";
  version = "0.4.0.1";
  sha256 = "0j260lvprgsi9qgjwji2cc25k0dzrw94h2527rwghik8baa1ha3r";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson csv filepath HDBC HDBCSqlite3 HStringTemplate pandoc parsec
    split text time unorderedContainers xhtml yaml
  ];
  meta = {
    homepage = "http://github.com/jgm/yst";
    description = "Builds a static website from templates and data in YAML or CSV files";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
