{ cabal }:

cabal.mkDerivation (self: {
  pname = "parseargs";
  version = "0.1.3.4";
  sha256 = "1n55ay42qiwm72fa63xbz5m5fi0ld5dr3vypmyz5mc0zzhqwxz2j";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://wiki.cs.pdx.edu/bartforge/parseargs";
    description = "Command-line argument parsing library for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
