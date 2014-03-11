{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.0.3";
  sha256 = "0l5r0iws4zbqvkb2nlzxq0zspaz9vhl2a5r43jrxh4cvqb6lbn3q";
  buildDepends = [
    conduit liftedBase monadControl network transformers
  ];
  testDepends = [ conduit ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Stream socket data using conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
