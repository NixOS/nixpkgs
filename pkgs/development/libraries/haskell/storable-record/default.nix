{ cabal, transformers, utilityHt }:

cabal.mkDerivation (self: {
  pname = "storable-record";
  version = "0.0.3";
  sha256 = "1mv2s4r7dqkl2fy0wjnywyr2zi2g53nkn0z72mgr8drkzdszzxx1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers utilityHt ];
  jailbreak = true;
  meta = {
    homepage = "http://code.haskell.org/~thielema/storable-record/";
    description = "Elegant definition of Storable instances for records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
