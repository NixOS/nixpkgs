{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.4.6";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.4.6.tar.gz;
    sha256 = "15l87pzmlwbxk6m4102g2zln4drq0l32qs60ccs5bpmcnky2lqya";
  };
  buildInputs = [
    pkgconfig x11 fontconfig freetype
    (if pngSupport then libpng else null)
  ];
  propagatedBuildInputs = [
    (if postscriptSupport then zlib else null)
    (if pngSupport then libpng else null)
  ];
  configureFlags =
    (if pdfSupport then ["--enable-pdf"] else []);
}
