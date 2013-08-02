{ cabal }:

cabal.mkDerivation (self: {
  pname = "hinotify";
  version = "0.3.6";
  sha256 = "0vzn9z90z9zk7g9pvbrgm6xyb4b5x2dai1c70fvmdi3w4h2x17zw";
  meta = {
    homepage = "https://github.com/kolmodin/hinotify.git";
    description = "Haskell binding to inotify";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
