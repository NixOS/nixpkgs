{ cabal, libX11, libXext, libXinerama, libXrandr, libXrender }:

cabal.mkDerivation (self: {
  pname = "X11";
  version = "1.6.0.1";
  sha256 = "0crbprh4m48l4yvbamgvvzrmm1d94lgbyqv1xsd37r4a3xh7qakz";
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
