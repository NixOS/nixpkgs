{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.0.4";
  sha256 = "1a7p3gs0rczx0rhz27410rr6fzy3l0nsj6kk5wi0nqvqfyh7jb9c";
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
