{ cabal, network, transformers }:

cabal.mkDerivation (self: {
  pname = "socket-activation";
  version = "0.1.0.0";
  sha256 = "1w10i9a10lq5gscwm1vf1w7pqkfyx3n108jw8dx4zdqhrh82lmwv";
  buildDepends = [ network transformers ];
  meta = {
    homepage = "https://github.com/sakana/haskell-socket-activation";
    description = "systemd socket activation library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
