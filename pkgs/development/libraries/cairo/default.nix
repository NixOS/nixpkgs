{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.4.14";
  
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.4.14.tar.gz;
    sha256 = "15l87pzmlwbxk6m4102g2zln4drq0l32qs60ccs5bpmcnky2lqya";
  };

  patches = [
    # http://bugs.freedesktop.org/show_bug.cgi?id=10989
    ./isspace.patch
  ];
  
  buildInputs = [
    pkgconfig x11 fontconfig freetype
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
