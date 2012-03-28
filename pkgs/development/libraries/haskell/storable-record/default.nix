{ cabal, transformers, utilityHt }:

cabal.mkDerivation (self: {
  pname = "storable-record";
  version = "0.0.2.4";
  sha256 = "5ed2680dcfc4c3d4fe605d23e797b847fe047b7acd3f4acfd82155c93e72b280";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers utilityHt ];
  meta = {
    homepage = "http://code.haskell.org/~thielema/storable-record/";
    description = "Elegant definition of Storable instances for records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
