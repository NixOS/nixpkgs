{ stdenv
, lib
, fetchurl
, fetchpatch
, cairo
, cmake
, curl
, fontconfig
, freetype
, lcms
, libiconv
, libintl
, libjpeg
, ninja
, openjpeg
, pkg-config
, zlib
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobject-introspection ? null
, utils ? false
, minimal ? false, suffix ? "glib"
}:

let
  version = "0.61.1";
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in
stdenv.mkDerivation rec {
  pname = "poppler-${suffix}";
  inherit version;

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${version}.tar.xz";
    sha256 = "1afdrxxkaivvviazxkg5blsf2x24sjkfj92ib0d3q5pm8dihjrhj";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # Fix internal crash: a negative number that should not be
    (fetchpatch {
      name = "CVE-2018-13988";
      url = "https://cgit.freedesktop.org/poppler/poppler/patch/?id=004e3c10df0abda214f0c293f9e269fdd979c5ee";
      sha256 = "1l8713s57xc6g81bldw934rsfm140fqc7ggd50ha5mxdl1b3app2";
    })
    # Fix internal crash: a negative number that should not be (not the above!)
    ./0.61-CVE-2019-9959.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    libiconv
    libintl
  ]
  ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt5Support qtbase
    ++ optional introspectionSupport gobject-introspection;

  # Not sure when and how to pass it.  It seems an upstream bug anyway.
  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  cmakeFlags = [
    (mkFlag true "XPDF_HEADERS")
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "A PDF rendering library";
    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
