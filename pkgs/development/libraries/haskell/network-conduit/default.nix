{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.5.0.1";
  sha256 = "1rk8a8n1yily20y3jr51zbd00m2c6ic8gxw9rnmkr2cfs963l2v5";
  buildDepends = [
    conduit liftedBase monadControl network transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Stream socket data using conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
