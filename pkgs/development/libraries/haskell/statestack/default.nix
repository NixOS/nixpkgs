{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "statestack";
  version = "0.2.0.3";
  sha256 = "0w5vw8jmnwbfyma4a3ggdm9jvxf3c18kpwbvcmvr5szifaqv9sgx";
  buildDepends = [ mtl transformers ];
  meta = {
    description = "Simple State-like monad transformer with saveable and restorable state";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
