{ cabal, ObjectName, openal, StateVar, Tensor }:

cabal.mkDerivation (self: {
  pname = "OpenAL";
  version = "1.4.0.2";
  sha256 = "19q4pd5i2w330qh895z0cgim4m4f4gxqf4ya1192fchqmgcz1svz";
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
