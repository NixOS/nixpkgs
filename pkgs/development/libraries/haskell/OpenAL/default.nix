{ cabal, ObjectName, openal, StateVar, Tensor }:

cabal.mkDerivation (self: {
  pname = "OpenAL";
  version = "1.4.0.1";
  sha256 = "180f84sjakhd1b8h5n3l92by2wmic20n6ax0z5fi3fvk9w73khyv";
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
