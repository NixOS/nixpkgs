{ cabal }:

cabal.mkDerivation (self: {
  pname = "bytedump";
  version = "1.0";
  sha256 = "1pf01mna3isx3i7m50yz3pw5ygz5sg8i8pshjb3yw8q41w2ba5xf";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-bytedump";
    description = "Flexible byte dump helpers for human readers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
