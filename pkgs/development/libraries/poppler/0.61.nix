{ stdenv, lib, fetchurl, cmake, ninja, pkgconfig, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobjectIntrospection ? null
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

  buildInputs = [ libiconv ] ++ libintlOrEmpty ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt5Support qtbase
    ++ optional introspectionSupport gobjectIntrospection;

  nativeBuildInputs = [ cmake ninja pkgconfig ];

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
