{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "network-transport";
  version = "0.2.0.2";
  sha256 = "1pipykqwbjmbkgkmk0ss2pvfp72rkxwmz49d1j5xi8b0rlfgw05c";
  buildDepends = [ binary transformers ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Network abstraction layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
