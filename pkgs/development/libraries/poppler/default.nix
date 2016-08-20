{ stdenv, lib, fetchurl, cmake, ninja, pkgconfig, libiconv, libintl
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobjectIntrospection ? null
, utils ? false, nss ? null
, minimal ? false, suffix ? "glib"
}:

stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";
  # beware: updates often break cups-filters build
  version = "0.67.0";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "1yb6agmcxf0ixqm65d4aknl0hgmswf94x0k59ic0qqav1wd4yjm3";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libiconv libintl ] ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt5Support qtbase
    ++ optional utils nss
    ++ optional introspectionSupport gobjectIntrospection;

  nativeBuildInputs = [ cmake ninja pkgconfig ];

  # Not sure when and how to pass it.  It seems an upstream bug anyway.
  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  cmakeFlags = {
    XPDF_HEADERS = true;
    GLIB = !minimal;
    CPP = !minimal;
    LIBCURL = !minimal;
    UTILS = utils;
    QT5 = qt5Support;
  };

  meta = with lib; {
    homepage = https://poppler.freedesktop.org/;
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code
      base. In addition it provides a number of tools that can be
      installed separately.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
