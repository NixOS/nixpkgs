{ cabal }:

cabal.mkDerivation (self: {
  pname = "sized-types";
  version = "0.3.4.0";
  sha256 = "0fpk7xpqzzylxbnxhz56lxzfnrhfibn0x7ahxl91x6biysnh714c";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.ittc.ku.edu/csdl/fpg/Tools";
    description = "Sized types in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
