{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.4";
  sha256 = "05iqy4llf42k20a4hdc7p3hx30v030ljwi469ps8xxx36c9c5kmf";
  meta = {
    homepage = "https://github.com/kolmodin/hinotify.git";
    description = "Haskell binding to inotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
