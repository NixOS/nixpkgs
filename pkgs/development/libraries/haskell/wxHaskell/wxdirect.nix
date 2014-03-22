{ cabal, filepath, parsec, strict, time }:

cabal.mkDerivation (self: {
  pname = "wxdirect";
  version = "0.90.1.0";
  sha256 = "06r8z4css7md35rcbi805407dcabcrb1knif9f7445aphwzgadr0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath parsec strict time ];
  preConfigure = "find . -type f -exec touch {} +";
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "helper tool for building wxHaskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
