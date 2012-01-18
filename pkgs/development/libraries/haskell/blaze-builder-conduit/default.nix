{ cabal, blazeBuilder, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-conduit";
  version = "0.0.1";
  sha256 = "1k9is6dknfqjnkqrvxs9z8cx0ffnnz4q02is9plndyg8pccgjfa9";
  buildDepends = [ blazeBuilder conduit text transformers ];
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
