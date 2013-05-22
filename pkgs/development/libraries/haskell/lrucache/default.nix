{ cabal }:

cabal.mkDerivation (self: {
  pname = "lrucache";
  version = "1.1.1.3";
  sha256 = "1djjxlyfrk3wpgc4h6xljpray09v7lc956202k9bxra24vj5f1lm";
  meta = {
    homepage = "http://github.com/chowells79/lrucache";
    description = "a simple, pure LRU cache";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
