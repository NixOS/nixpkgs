{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.4.4";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.4.4.tar.gz;
    sha1 = "71a7ce8352500944f7b2b73d4dc25ee947ec56ec";
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
