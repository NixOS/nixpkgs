{ cabal }:

cabal.mkDerivation (self: {
  pname = "parseargs";
  version = "0.1.3.2";
  sha256 = "1ncdbjzfkhb1f3aznsci26kss9nrv3iilc65q5xdl9nly8p837mv";
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
