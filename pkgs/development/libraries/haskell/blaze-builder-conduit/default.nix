{ cabal, blazeBuilder, Cabal, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-conduit";
  version = "0.2.0";
  sha256 = "13fcxmzw4xz7y271vdf6w6fj6isninjcxnm7h7gbk4yf31wx831r";
  buildDepends = [ blazeBuilder Cabal conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Convert streams of builders to streams of bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
