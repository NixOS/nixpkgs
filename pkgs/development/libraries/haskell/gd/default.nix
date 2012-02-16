{ cabal, Cabal, expat, fontconfig, freetype, gd, libjpeg, libpng
, zlib
}:

cabal.mkDerivation (self: {
  pname = "gd";
  version = "3000.7.1";
  sha256 = "07rb02jfmz6bw853b6snw1inby9qgaygdmlsid35snc2xn2ylb50";
  buildDepends = [ Cabal ];
  extraLibraries = [
    expat fontconfig freetype gd libjpeg libpng zlib
  ];
  meta = {
    description = "A Haskell binding to a subset of the GD graphics library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
