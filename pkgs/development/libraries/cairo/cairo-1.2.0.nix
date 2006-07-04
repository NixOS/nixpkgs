{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.2.0";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.2.0.tar.gz;
    sha1 = "c5da7f89cdd3782102357f99a47f516d11661e92";
  };
  buildInputs = [
    pkgconfig x11 fontconfig freetype
    (if pngSupport then libpng else null)
  ];
  propagatedBuildInputs = [
    (if postscriptSupport then zlib else null)
  ];
  configureFlags =
    (if pdfSupport then ["--enable-pdf"] else []);
}
