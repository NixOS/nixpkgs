{ stdenv, lib, fetchurl, cmake, ninja, pkgconfig, libiconv, libintl
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg, fetchpatch
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobject-introspection ? null
, utils ? false
, minimal ? false, suffix ? "glib"
}:

let
  version = "0.61.0";
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in
stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "0zrbb1b77k6bm2qdnra08jnbyllv6vj29790igmp6fzs59xf3kak";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "CVE-2018-13988";
      url = "https://cgit.freedesktop.org/poppler/poppler/patch/?id=004e3c10df0abda214f0c293f9e269fdd979c5ee";
      sha256 = "1l8713s57xc6g81bldw934rsfm140fqc7ggd50ha5mxdl1b3app2";
    })
  ];

  buildInputs = [ libiconv libintl ] ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt5Support qtbase
    ++ optional introspectionSupport gobject-introspection;

  nativeBuildInputs = [ cmake ninja pkgconfig ];

  # Not sure when and how to pass it.  It seems an upstream bug anyway.
  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  cmakeFlags = [
    (mkFlag true "XPDF_HEADERS")
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
  ];

  meta = with lib; {
    homepage = https://poppler.freedesktop.org/;
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
