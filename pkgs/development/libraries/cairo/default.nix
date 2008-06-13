{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng, pixman
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.6.4";
  
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.6.4.tar.gz;
    sha1 = "9d990fe39a125ceb07221623c237cd7015855d5c";
  };

  buildInputs = [
    pkgconfig x11 fontconfig freetype pixman
  ];
  
  propagatedBuildInputs =
    stdenv.lib.optional postscriptSupport zlib ++
    stdenv.lib.optional pngSupport libpng;
    
  configureFlags =
    (if pdfSupport then ["--enable-pdf"] else []);

  meta = {
    description = "A 2D graphics library with support for multiple output devices";
    homepage = http://cairographics.org/;
  };
}
