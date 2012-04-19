{ cabal, parsec, strict, time }:

cabal.mkDerivation (self: {
  pname = "wxdirect";
  version = "0.90.0.1";
  sha256 = "04jslgxw601g6wh8f2wrdnipzh6x0487kfxb89fkgfgjhxrkfyr3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec strict time ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "helper tool for building wxHaskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
