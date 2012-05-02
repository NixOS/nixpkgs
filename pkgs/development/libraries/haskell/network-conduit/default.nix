{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.4.0";
  sha256 = "0h0s33nxihd4zy9mvy2vpdrpvjapacbl69ndsw5zrbqhwbpz3mzs";
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
