{cabal, gtk2hsBuildtools, pkgconfig, glibc, cairo, zlib, mtl}:

cabal.mkDerivation (self : {
  pname = "cairo";
  version = "0.11.1";
  sha256 = "6d7209bcdb92b09437980c51646c324f501edd2893393e48aa185462dfc07b58";
  extraBuildInputs = [pkgconfig glibc cairo zlib gtk2hsBuildtools];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Binding to the Cairo library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
