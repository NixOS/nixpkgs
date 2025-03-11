{
  stdenv,
  lib,
  fetchurl,
  cmake,
  phonon,
  pkg-config,
  libvlc,
  extra-cmake-modules,
  qttools,
  qtbase,
  qtx11extras,
  debug ? false,
}:

stdenv.mkDerivation rec {
  pname = "phonon-backend-vlc";
  version = "0.11.3";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Xmn97MsGDH5rWSTO8uZb7loIrOQScAW5U0TtMHfcY5c=";
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

  cmakeBuildType = if debug then "Debug" else "Release";

  meta = with lib; {
    homepage = "https://community.kde.org/Phonon";
    # Dev repo is at https://invent.kde.org/libraries/phonon-vlc
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    license = with licenses; [
      bsd3
      lgpl21Plus
    ];
  };
}
