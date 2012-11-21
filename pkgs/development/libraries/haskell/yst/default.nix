{ cabal, csv, filepath, HDBC, HDBCSqlite3, HsSyck, HStringTemplate
, pandoc, parsec, split, time, utf8String, xhtml
}:

cabal.mkDerivation (self: {
  pname = "yst";
  version = "0.3.0.1";
  sha256 = "17jp9vdbpp82wzsj8rhp5nh6fbmgm2xrclfnb7jl4gjwls7xggrv";
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
