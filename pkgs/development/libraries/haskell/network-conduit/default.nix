{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.4.0.1";
  sha256 = "0xmfhar4knyn01xyigrp4lymb1vcsahd9v12i6rrqzi10mdcz6bl";
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
