{ cabal, ObjectName, openal, StateVar, Tensor }:

cabal.mkDerivation (self: {
  pname = "OpenAL";
  version = "1.4.0.0";
  sha256 = "1vn9r8fd4zwqm8a9d8bgvi9vs1lmygn8sw1rlv819b5wmjwz3ms2";
  buildDepends = [ ObjectName StateVar Tensor ];
  extraLibraries = [ openal ];
  meta = {
    homepage = "http://connect.creativelabs.com/openal/";
    description = "A binding to the OpenAL cross-platform 3D audio API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
