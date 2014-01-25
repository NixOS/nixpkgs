{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.0.1.1";
  sha256 = "1mji8zb0chnnxl7z4dgijls6szfa6c47zmhx0v1dc9k27bnc0mhx";
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
