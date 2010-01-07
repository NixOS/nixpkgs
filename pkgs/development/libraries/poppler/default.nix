{ fetchurl, stdenv, qt4Support ? false, qt4 ? null
, cairo, freetype, fontconfig, zlib, libjpeg
, pkgconfig, glib, gtk }:

assert qt4Support -> (qt4 != null);

stdenv.mkDerivation rec {
  name = "poppler-0.12.3";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "1k7vilpz0ipnmw9dfpb3rqkhlm4rqcnkn3bhhp14di2h55nzwkvs";
  };

  buildInputs = [pkgconfig zlib glib cairo freetype fontconfig libjpeg gtk]
    ++ (if qt4Support then [qt4] else []);

  configureFlags =
    ''
      --enable-exceptions --enable-cairo --enable-splash
      --enable-poppler-glib --enable-zlib --enable-xpdf-headers
    ''
    + (if qt4Support then "--enable-qt-poppler" else "--disable-qt-poppler");

  patches = [ ./GDir-const.patch ];

  preConfigure = "sed -e '/jpeg_incdirs/s@/usr@${libjpeg}@' -i configure";

  # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
  # such as `../../../test/unittestcases/UseNone.pdf'.
  doCheck = !qt4Support;

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Poppler, a PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = "GPLv2";
  };
}
