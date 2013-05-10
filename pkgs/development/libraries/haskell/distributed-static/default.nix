{ cabal, binary, rank1dynamic }:

cabal.mkDerivation (self: {
  pname = "distributed-static";
  version = "0.2.1.1";
  sha256 = "08y9554x6avjwdmbf33fw1pw1wl8qmgfngmgb6vgad88krnixq1h";
  buildDepends = [ binary rank1dynamic ];
  meta = {
    homepage = "http://www.github.com/haskell-distributed/distributed-process";
    description = "Compositional, type-safe, polymorphic static values and closures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
