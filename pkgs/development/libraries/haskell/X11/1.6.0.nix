{ cabal, libX11, libXext, libXinerama, libXrandr, libXrender, syb
}:

cabal.mkDerivation (self: {
  pname = "X11";
  version = "1.6.0";
  sha256 = "0jjnr4490mkdrmq3lvv7hha7rc9vbwsxlwsvcv56q6zgjx4zwf8j";
  buildDepends = [ syb ];
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
