{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.3";
  sha256 = "0z8pd5zva25zii5kkh807kdkn4j9w9z74f2dw4kyflwidn0063fr";
  meta = {
    homepage = "https://github.com/kolmodin/hinotify.git";
    description = "Haskell binding to inotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
