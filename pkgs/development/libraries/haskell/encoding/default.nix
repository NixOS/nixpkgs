{ cabal, binary, extensibleExceptions, HaXml, mtl, regexCompat }:

cabal.mkDerivation (self: {
  pname = "encoding";
  version = "0.7";
  sha256 = "1h6yki4d3912sr8nsk1cff2pdvzw8ys6xnzi97b5ay1f8i28bmi5";
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
