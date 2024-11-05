{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  qt5platform-plugins,
  dtkwidget,
  dtkdeclarative,
  deepin-ocr-plugin-manager,
  libraw,
  freeimage,
}:

stdenv.mkDerivation rec {
  pname = "deepin-image-viewer";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-YT3wK+ELXjgtsXbkiCjQF0zczQi89tF1kyIQtl9/mMA=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-libraw-0_21.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/2ff11979704dd7156a7e7c3bae9b30f08894063d/trunk/libraw-0.21.patch";
      hash = "sha256-I/w4uiANT8Z8ud/F9WCd3iRHOfplu3fpqnu8ZIs4C+w=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qt5platform-plugins
    dtkwidget
    dtkdeclarative
    deepin-ocr-plugin-manager
    libraw
    freeimage
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "Image viewing tool with fashion interface and smooth performance";
    homepage = "https://github.com/linuxdeepin/deepin-image-viewer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
