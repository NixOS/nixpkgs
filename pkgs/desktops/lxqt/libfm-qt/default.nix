{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, lxqt-menu-data
, pcre
, libexif
, xorg
, libfm
, menu-cache
, qtx11extras
, qttools
, gitUpdater
}:

mkDerivation rec {
  pname = "libfm-qt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    hash = "sha256-QxPYSA7537K+/dRTxIYyg+Q/kj75rZOdzlUsmSdQcn4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    lxqt-menu-data
    pcre
    libexif
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.libXdmcp
    qtx11extras
    libfm
    menu-cache
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
