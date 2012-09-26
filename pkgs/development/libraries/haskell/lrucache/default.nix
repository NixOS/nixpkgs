{ cabal }:

cabal.mkDerivation (self: {
  pname = "lrucache";
  version = "1.1.1";
  sha256 = "05y0b2dbbp017hkbr0pz943956dm31g5xhma4bqnh49yd4lyn5l9";
  meta = {
    homepage = "http://github.com/chowells79/lrucache";
    description = "a simple, pure LRU cache";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
