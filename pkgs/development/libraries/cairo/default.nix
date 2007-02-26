{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.2.6";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.2.6.tar.gz;
    sha1 = "b86b4017a9abd565ef11c72b7faee9082a04118f";
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
