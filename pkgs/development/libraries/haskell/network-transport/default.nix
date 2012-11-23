{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "network-transport";
  version = "0.3.0.1";
  sha256 = "1iijcd864znik83smk1bjidinm199wri5fdyrhnffj0n35knrvas";
  buildDepends = [ binary transformers ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Network abstraction layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
