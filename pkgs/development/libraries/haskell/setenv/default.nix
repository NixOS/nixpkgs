{ cabal }:

cabal.mkDerivation (self: {
  pname = "setenv";
  version = "0.1.1";
  sha256 = "1j0fj8nrx9z90kghasxjx5jycz9y9xdi7mrxmgnsc14csa65rhb8";
  doCheck = false;
  meta = {
    description = "A cross-platform library for setting environment variables";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
