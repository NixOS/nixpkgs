{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  dtk6widget,
  qt6Packages,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "qt6integration";
  version = "6.0.33";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-fxeXjUn1hJUE1Le24sqVEvKBX9Uo8qUVjr3sfz/5cQQ=";
  };

  patches = [
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/deepin-qt6integration/-/raw/e85e6836919d8e8424e800d7d4c8681bb23c29f9/qt-6.9.patch";
      hash = "sha256-GJH25cOEcA5Zep6FABwlRXU7HfpgMXNJzsbmWQdzx+Y=";
    })
    (fetchpatch {
      name = "missing-include.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/deepin-qt6integration/-/raw/300e6ac2a166ce214d64c9b16acc57d31de0604a/missing-include.patch";
      hash = "sha256-IFSfnIFcXAcmzfAOId2ew+YUHxHK6+JfJ/t96FR7rhk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dtk6widget
    qt6Packages.qtbase
    gtest
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DPLUGIN_INSTALL_BASE_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtPluginPrefix}"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt platform theme integration plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt6integration";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
}
