{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.2.2";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.2.2.tar.gz;
    sha1 = "859b9ed4eaa200a03b9e41ccc45f3799742e6c5c";
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
