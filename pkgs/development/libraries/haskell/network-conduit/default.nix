{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.0.2.1";
  sha256 = "1dq7pwimjkr0wpyjphbvjy3klkcjl8jin76am5jbz3cxk1dr20jk";
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
