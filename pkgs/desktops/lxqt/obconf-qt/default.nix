{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, libSM
, libXdmcp
, libpthreadstubs
, lxqt-build-tools
, openbox
, pcre
, pkg-config
, qtbase
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "obconf-qt";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-uF90v56BthEts/Jy+a6kH2b1QFHCtft4ZLxyi/K/Vnc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libSM
    libXdmcp
    libpthreadstubs
    openbox
    pcre
    qtbase
    qtwayland
  ];

  patches = [
    (fetchpatch {
      name = "obconf-qt.port-to-qt6";
      url = "https://patch-diff.githubusercontent.com/raw/lxqt/obconf-qt/pull/230.patch";
      hash = "sha256-XLt8+/4oMXeli07qTAGc73U9RD1fGYqxTX0QdhuXpII=";
    })
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/obconf-qt";
    description = "The Qt port of obconf, the Openbox configuration tool";
    mainProgram = "obconf-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
