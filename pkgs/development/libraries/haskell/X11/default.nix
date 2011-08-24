{cabal, syb, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

cabal.mkDerivation (self : {
  pname = "X11";
  version = "1.5.0.0";
  sha256 = "653ff8aa4053574a36dbb1729459df6e5a1a87a223bc3eeced8e40c6e3a5406f";
  propagatedBuildInputs = [libX11 syb] ++ (if xineramaSupport then [libXinerama libXext] else []);
  meta = {
    homepage = "http://code.haskell.org/X11";
    description = "A binding to the X11 graphics library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
