{ cabal, binary, extensibleExceptions, HaXml, mtl, regexCompat }:

cabal.mkDerivation (self: {
  pname = "encoding";
  version = "0.6.7.2";
  sha256 = "0b1z5824vdkcc51bd1vgcbaniw3fv9dmd5qczjc89b5lhrl7qq0d";
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
