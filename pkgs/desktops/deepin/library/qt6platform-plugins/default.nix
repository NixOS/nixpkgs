{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, mtdev
, cairo
, xorg
, qt6Packages
}:

stdenv.mkDerivation rec {
  pname = "qt6platform-plugins";
  version = "6.0.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-0/hwsdB0UNzlekxfdKeItW2lXTMTzEtBR2hS153woLo=";
  };

  patches = [
    (fetchpatch {
      name = "support-to-qt_6_7_1.patch";
      url = "https://github.com/linuxdeepin/qt6platform-plugins/commit/88ba963d11355391d62501cd5a6da9e3d5e9ddce.patch";
      hash = "sha256-9NiKIdY9PXBYgKQGRf5pFV+tNrHe7BjbVrnwII9lLFI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mtdev
    cairo
    xorg.libSM
    qt6Packages.qtbase
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DINSTALL_PATH=${placeholder "out"}/${qt6Packages.qtbase.qtPluginPrefix}/platforms"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt platform plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt6platform-plugins";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
