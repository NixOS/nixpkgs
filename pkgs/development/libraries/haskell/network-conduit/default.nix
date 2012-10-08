{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.6.0";
  sha256 = "0y296v8b6xrxs9jw6az6flz9nsqgk60cnpc954pmp6mi5q8mbv7i";
  buildDepends = [
    conduit liftedBase monadControl network transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Stream socket data using conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
