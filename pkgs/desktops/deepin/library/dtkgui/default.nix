{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, qttools
, wrapQtAppsHook
, librsvg
, lxqt
, dtkcore
, qtimageformats
, freeimage
}:

stdenv.mkDerivation rec {
  pname = "dtkgui";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-r6ZwGPiK6CcKEg8RoHV07wJbQI3idJFV3WFtuKim8n4=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    lxqt.libqtxdg
  ];

  propagatedBuildInputs = [
    dtkcore
    librsvg
    qtimageformats
    freeimage
  ];

  cmakeFlags = [
    "-DDVERSION=${version}"
    "-DBUILD_DOCS=OFF"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
  ];

  meta = with lib; {
    description = "Deepin Toolkit, gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtkgui";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
