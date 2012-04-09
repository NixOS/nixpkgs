{ cabal, blazeBuilder, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-conduit";
  version = "0.4.0.1";
  sha256 = "059i7k49vpwsd7dlm4di4k5xhiparq71h8qagssw8a4nsk9jglvp";
  buildDepends = [ blazeBuilder conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Convert streams of builders to streams of bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
