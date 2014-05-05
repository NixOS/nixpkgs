{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-compat";
  version = "0.3";
  sha256 = "0dncakmg4wszi20apfzwdlgp69pka8bwwdrg1pl7nrn3sybq97yf";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/transformers-compat/";
    description = "A small compatibility shim exposing the new types from transformers 0.3 and 0.4 to older Haskell platforms.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
