{ cabal, transformers, utilityHt }:

cabal.mkDerivation (self: {
  pname = "storable-record";
  version = "0.0.2.5";
  sha256 = "078vwwcr47d3dmzkhxr7ggjkq9d5rnxv4z8p049kdnmzfbcmisn3";
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
