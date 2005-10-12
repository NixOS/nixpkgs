{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.0.2";
  src = fetchurl {
    url = http://cairographics.org/releases/cairo-1.0.2.tar.gz;
    sha1 = "3a425049499b0b067ed4dc60d94b4d0819c0841b";
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
