{ cabal }:

cabal.mkDerivation (self: {
  pname = "word8";
  version = "0.0.2";
  sha256 = "0ij8l5h9kj93srsizwxiss4jcgj0hy2gsskw88l58lgd2v4c9dnb";
  meta = {
    description = "Word8 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
