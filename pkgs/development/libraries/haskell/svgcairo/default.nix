{cabal, gtk2hsBuildtools, cairo, glib, mtl, pkgconfig, librsvg, glibc}:

cabal.mkDerivation (self : {
  pname = "svgcairo";
  version = "0.12.0";
  sha256 = "1zialw59njmq0sfz9f0rx6v50d4bvld2ivmwljkp5bmxii3hcjl3";
  extraBuildInputs = [pkgconfig librsvg glibc gtk2hsBuildtools];
  propagatedBuildInputs = [cairo glib mtl];
  meta = {
    description = "Binding to the Cairo library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
