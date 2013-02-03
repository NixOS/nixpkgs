{ cabal, mtl, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.2.7";
  sha256 = "0a5zjhrbdp8hwmkc709i2qwnxx4lafrp6wssdms6g5l97a52bdc2";
  buildDepends = [ mtl network parsec ];
  meta = {
    homepage = "https://github.com/haskell/HTTP";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
