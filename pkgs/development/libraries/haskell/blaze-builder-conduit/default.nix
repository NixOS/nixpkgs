{ cabal, blazeBuilder, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-conduit";
  version = "0.5.0.1";
  sha256 = "1avbgrgqzryqv717714s0418lknm0lqzkis3hia00qhy762amlcn";
  buildDepends = [ blazeBuilder conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Convert streams of builders to streams of bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
