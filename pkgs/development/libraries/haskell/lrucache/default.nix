{ cabal }:

cabal.mkDerivation (self: {
  pname = "lrucache";
  version = "1.1.1.2";
  sha256 = "1s4yrjfmndsrxbfrn8xcxyif65nsdx4b34ki3ajznrsvsl1cc137";
  meta = {
    homepage = "http://github.com/chowells79/lrucache";
    description = "a simple, pure LRU cache";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
