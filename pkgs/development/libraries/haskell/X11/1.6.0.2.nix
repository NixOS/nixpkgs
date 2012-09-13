{ cabal, libX11, libXext, libXinerama, libXrandr, libXrender }:

cabal.mkDerivation (self: {
  pname = "X11";
  version = "1.6.0.2";
  sha256 = "0z1g93k2zbkb9is2zy6pfwp13bv11cvs30b9cz253wjv2liphshw";
  extraLibraries = [
    libX11 libXext libXinerama libXrandr libXrender
  ];
  meta = {
    homepage = "https://github.com/haskell-pkg-janitors/X11";
    description = "A binding to the X11 graphics library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
