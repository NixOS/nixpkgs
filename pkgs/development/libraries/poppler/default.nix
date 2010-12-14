{ fetchurl, stdenv, qt4Support ? false, qt4, cairo, freetype, fontconfig, zlib,
  libjpeg, pixman, curl, libpthreadstubs, libXau, libXdmcp, openjpeg,
  libxml2, pkgconfig, glib, gtk, cmake, lcms }:

stdenv.mkDerivation rec {
  name = "poppler-0.14.5";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "0k41cj0yp3l7854y1hlghn2cgqmqq6hw5iz8i84q0w0s9iy321f8";
  };

  propagatedBuildInputs = [zlib glib cairo freetype fontconfig libjpeg gtk lcms
    pixman curl libpthreadstubs libXau libXdmcp openjpeg libxml2 stdenv.gcc.libc]
    ++ (if qt4Support then [qt4] else []);

  buildInputs = [ pkgconfig cmake ];

  cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

  # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
  # such as `../../../test/unittestcases/UseNone.pdf'.
#doCheck = !qt4Support;
  checkTarget = "test";

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Poppler, a PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    platforms = if qt4Support
      then qt4.meta.platforms
      else stdenv.lib.platforms.all;

    license = "GPLv2";
  };
}
