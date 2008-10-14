{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng, pixman, libxcb, xcbutil
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.8.0";
  
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.8.0.tar.gz;
    sha1 = "8a689ca47c24216f37bb8cabae21ff08a7f47899";
  };

  buildInputs = [
    pkgconfig x11 fontconfig freetype pixman libxcb xcbutil
  ];

  propagatedBuildInputs =
    stdenv.lib.optional postscriptSupport zlib ++
    stdenv.lib.optional pngSupport libpng;
    
  configureFlags = ["--disable-static" "--enable-xcb"] ++
    stdenv.lib.optional pdfSupport "--enable-pdf";

  meta = {
    description = "A 2D graphics library with support for multiple output devices";
    homepage = http://cairographics.org/;
  };
}
