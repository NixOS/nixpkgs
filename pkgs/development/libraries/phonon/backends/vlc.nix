{ stdenv, lib, fetchurl, cmake, phonon, pkg-config, libvlc
, extra-cmake-modules, qttools, qtbase, qtx11extras
, debug ? false
}:

with lib;

stdenv.mkDerivation rec {
  pname = "phonon-backend-vlc";
  version = "0.11.1";

  meta = with lib; {
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
    libvlc
    qtbase
    qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    extra-cmake-modules
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}"
  ];
}
