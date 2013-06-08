{ cabal }:

cabal.mkDerivation (self: {
  pname = "newtype";
  version = "0.2";
  sha256 = "0ng4i5r73256gzwl6bw57h0abqixj783c3ggph1hk2wsplx0655p";
  meta = {
    description = "A typeclass and set of functions for working with newtypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
