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
