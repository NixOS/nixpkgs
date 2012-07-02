{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.2";
  sha256 = "0gr9rv1af6w7g2hbjhz1livi5zfhzdswjyapvjz3d7cga906bj48";
  meta = {
    homepage = "http://code.haskell.org/hinotify/README.html";
    description = "Haskell binding to INotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
