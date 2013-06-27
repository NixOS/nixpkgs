{ fetchurl, stdenv, cairo, freetype, fontconfig, zlib
, libjpeg, curl, libpthreadstubs, xorg, openjpeg
, libxml2, pkgconfig, cmake, lcms2, libiconvOrEmpty
, glibSupport ? false, glib, gtk3Support ? false, gtk3 # gtk2 no longer accepted
, qt4Support ? false, qt4 ? null
}:

stdenv.mkDerivation rec {
  name = "poppler-0.18.4";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "0bnl05al7mjndp2h0355946j59nfw76f5v0x57d47q68rm412hik";
  };

  propagatedBuildInputs = with xorg;
    [ zlib cairo freetype fontconfig libjpeg lcms2 curl
      libpthreadstubs libxml2 stdenv.gcc.libc
      libXau libXdmcp libxcb libXrender libXext
      openjpeg
    ]
    ++ stdenv.lib.optional glibSupport glib
    ++ stdenv.lib.optional gtk3Support gtk3
    ++ stdenv.lib.optional qt4Support qt4;

  nativeBuildInputs = [ pkgconfig cmake ] ++ libiconvOrEmpty;

  cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

  patches = [ ./datadir_env.patch ];

  # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
  # such as `../../../test/unittestcases/UseNone.pdf'.
  #doCheck = !qt4Support;
  checkTarget = "test";

  enableParallelBuilding = true;

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
