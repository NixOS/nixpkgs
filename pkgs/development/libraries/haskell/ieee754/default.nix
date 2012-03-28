{ cabal }:

cabal.mkDerivation (self: {
  pname = "ieee754";
  version = "0.7.3";
  sha256 = "0gq747h15inxbxbgmzmchb9a8p57rhv3bmj69idx5arh0d3whgv0";
  meta = {
    homepage = "http://github.com/patperry/hs-ieee754";
    description = "Utilities for dealing with IEEE floating point numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
