{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, dtkwidget
, qt5integration
, qt5platform-plugins
, gio-qt
, udisks2-qt5
, image-editor
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, libraw
, libexif
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "deepin-image-viewer";
  version = "5.9.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-5A6K47NcMkvncZIF5CXeHYYZWEHQ4YDnPDQr2axCmaI=";
  };

  patches = [
    ./0001-fix-install-path-for-nix.patch
    (fetchpatch {
      name = "chore: use GNUInstallDirs in CmakeLists";
      url = "https://github.com/linuxdeepin/deepin-image-viewer/commit/4a046e6207fea306e592fddc33c1285cf719a63d.patch";
      sha256 = "sha256-aIgYmq6WDfCE+ZcD0GshxM+QmBWZGjh9MzZcTMrhBJ0=";
    })
    (fetchpatch {
      name = "fix build with libraw 0.21";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/2ff11979704dd7156a7e7c3bae9b30f08894063d/trunk/libraw-0.21.patch";
      sha256 = "sha256-I/w4uiANT8Z8ud/F9WCd3iRHOfplu3fpqnu8ZIs4C+w=";
    })
  ];

  postPatch = ''
    substituteInPlace src/com.deepin.ImageViewer.service \
      --replace "/usr/bin/deepin-image-viewer" "$out/bin/deepin-image-viewer"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    gio-qt
    udisks2-qt5
    image-editor
    libraw
    libexif
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "An image viewing tool with fashion interface and smooth performance";
    homepage = "https://github.com/linuxdeepin/deepin-image-viewer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
