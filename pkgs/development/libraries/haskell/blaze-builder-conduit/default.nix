{ cabal, blazeBuilder, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-conduit";
  version = "0.4.0";
  sha256 = "0lpm480xc2y3syv42l3v7v6yhhnfr69bj7vc80fj0074h5288vjy";
  buildDepends = [ blazeBuilder conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Convert streams of builders to streams of bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
