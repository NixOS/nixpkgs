{ stdenv, lib, fetchurl, cmake, ninja, pkgconfig, libiconv, libintl, fetchpatch
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobjectIntrospection ? null
, utils ? false, nss ? null
, minimal ? false, suffix ? "glib"
}:

let # beware: updates often break cups-filters build
  version = "0.66.0";
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in
stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "1rzar5f27xzkjih07yi8kxcinvk4ny4nhimyacpvqx7vmlqn829c";
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

  patches = lib.optional stdenv.isDarwin (fetchpatch {
    url = "https://cgit.freedesktop.org/poppler/poppler/patch/?id=267228bb071016621c80fc8514927905164aaeea";
    sha256 = "0i2sbxz1mrsnj75qgqaadayjgs48ay2mhrbkij95djy6am44m54k";
  });

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
      Poppler is a PDF rendering library based on the xpdf-3.0 code
      base. In addition it provides a number of tools that can be
      installed separately.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
