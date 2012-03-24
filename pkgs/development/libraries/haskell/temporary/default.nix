{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "temporary";
  version = "1.1.2.3";
  sha256 = "1x4jljggbcdq90h578yyvc8z1i9zmlhvqfz2dym8kj8pq4qiwixd";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.github.com/batterseapower/temporary";
    description = "Portable temporary file and directory support for Windows and Unix, based on code from Cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
