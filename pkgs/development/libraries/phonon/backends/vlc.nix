{ stdenv, lib, fetchurl, cmake, phonon, pkg-config, libvlc
, extra-cmake-modules, qttools, qtbase, qtx11extras
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "phonon-backend-vlc";
  version = "0.11.2";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-xsM7/GjRN/DlegKeS3mMu5D1Svb3Ma9JZ3hXeRzNU6U=";
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

  meta = with lib; {
    homepage = "https://phonon.kde.org/";
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl2Plus ];
  };
}
