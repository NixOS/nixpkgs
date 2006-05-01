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
    url = http://cairographics.org/releases/cairo-1.0.4.tar.gz;
    sha1 = "89e72202e5b51a8914fce60f52f7c51ecdea982a";
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
