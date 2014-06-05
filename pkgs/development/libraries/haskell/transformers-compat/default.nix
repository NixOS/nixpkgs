{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-compat";
  version = "0.3.3.4";
  sha256 = "1hab41ggyaxr4xn2szv8y9fg9np8zi8ifhimr33fspid1jz14xr5";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/transformers-compat/";
    description = "A small compatibility shim exposing the new types from transformers 0.3 and 0.4 to older Haskell platforms.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
