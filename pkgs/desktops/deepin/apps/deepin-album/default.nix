{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtbase
, qtsvg
, udisks2-qt5
, gio-qt
, image-editor
, glibmm
, freeimage
, opencv
, ffmpeg
, ffmpegthumbnailer
}:

stdenv.mkDerivation rec {
  pname = "deepin-album";
  version = "5.10.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-S/oVRD72dtpnvfGV6YfN5/syrmWA44H/1BbmAe0xjAY=";
  };

  # This patch should be removed after upgrading to 6.0.0
  postPatch = ''
    substituteInPlace libUnionImage/CMakeLists.txt \
      --replace "/usr" "$out"
    substituteInPlace src/CMakeLists.txt \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    udisks2-qt5
    gio-qt
    image-editor
    glibmm
    freeimage
    opencv
    ffmpeg
    ffmpegthumbnailer
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "A fashion photo manager for viewing and organizing pictures";
    homepage = "https://github.com/linuxdeepin/deepin-album";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
