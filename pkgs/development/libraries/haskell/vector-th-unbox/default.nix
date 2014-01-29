{ cabal, dataDefault, vector }:

cabal.mkDerivation (self: {
  pname = "vector-th-unbox";
  version = "0.2.0.2";
  sha256 = "1c8xy0rcl8il9ssclqshwi8dd2xx6bl1rfhrfm9h7wklw64db9xp";
  buildDepends = [ vector ];
  testDepends = [ dataDefault vector ];
  meta = {
    description = "Deriver for Data.Vector.Unboxed using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
