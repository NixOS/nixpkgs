{ cabal, binary, extensibleExceptions, HaXml, mtl, regexCompat }:

cabal.mkDerivation (self: {
  pname = "encoding";
  version = "0.7.0.1";
  sha256 = "18s6cfcjwjx5dja14rf35rx71cbpr8ylg4x29ffx2blsk8ib9zxh";
  buildDepends = [
    binary extensibleExceptions HaXml mtl regexCompat
  ];
  meta = {
    homepage = "http://code.haskell.org/encoding/";
    description = "A library for various character encodings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
