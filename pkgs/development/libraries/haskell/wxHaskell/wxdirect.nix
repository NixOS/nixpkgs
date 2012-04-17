{ cabal, parsec, strict, time }:

cabal.mkDerivation (self: {
  pname = "wxdirect";
  version = "0.90";
  sha256 = "0vlqvj9sys5d2x9ccpq0yxqbsq060g4jb6xrckjspxb605c98r3r";
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
