{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-compat";
  version = "0.1.1.1";
  sha256 = "0i0bcfmqsnqa8fyp81virr5bh3hk23261xyx28jcfamrc18ly9ij";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/transformers-compat/";
    description = "A small compatibility shim exposing the new types from transformers 0.3 to older Haskell platforms.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
