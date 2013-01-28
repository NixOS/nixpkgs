{ cabal, conduit, liftedBase, monadControl, network, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "0.6.2.2";
  sha256 = "1v8abhw977hr78hkshrbxy04abbbhafvvnhr4xxgqc0phwch02mc";
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
