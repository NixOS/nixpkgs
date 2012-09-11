{ cabal }:

cabal.mkDerivation (self: {
  pname = "hscolour";
  version = "1.20.3";
  sha256 = "15ix93sw4p7g5ln2halcgqppdc0i0vmkzcjzxvqzkk9yp9pq3nrs";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://code.haskell.org/~malcolm/hscolour/";
    description = "Colourise Haskell code";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
