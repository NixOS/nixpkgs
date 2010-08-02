{cabal, gtk2hsBuildtools, pkgconfig, glibc, cairo, zlib, mtl}:

cabal.mkDerivation (self : {
  pname = "cairo";
  version = "0.11.0";
  sha256 = "f7971180bbd40c2a19b2e97fe40bd4a296b3aaf3edcf6621009780d723405c5a";
  extraBuildInputs = [pkgconfig glibc cairo zlib gtk2hsBuildtools];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Binding to the Cairo library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
