{ stdenv, lib, fetchurl, cmake, phonon, pkgconfig, vlc
, extra-cmake-modules, qttools, qtbase, qtx11extras
, debug ? false
}:

with lib;

stdenv.mkDerivation rec {
  pname = "phonon-backend-vlc";
  version = "0.11.1";

  meta = with stdenv.lib; {
    homepage = "https://phonon.kde.org/";
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl2Plus ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "1vp52i5996khpxs233an7mlrzdji50gcs58ig8nrwfwlgyb1xnfc";
  };

  buildInputs = [
    phonon
    vlc
    qtbase
    qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    extra-cmake-modules
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}"
  ];
}
