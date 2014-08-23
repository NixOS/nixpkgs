{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-compat";
  version = "0.3.3.3";
  sha256 = "18cqghf0gc97j9qnlfnwwhvfm8j4sk99rm0xv3bf6ml8slk7njx7";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/transformers-compat/";
    description = "A small compatibility shim exposing the new types from transformers 0.3 and 0.4 to older Haskell platforms.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
