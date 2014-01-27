{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.0.2";
  sha256 = "00x9m4lsh4hkvw6z6kqd3q7hpy2q905vcnj9x1wbn6swz621h4rw";
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
