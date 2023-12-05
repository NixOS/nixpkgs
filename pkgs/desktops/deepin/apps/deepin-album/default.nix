{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, dtkdeclarative
, qt5integration
, qt5platform-plugins
, qtbase
, qtsvg
, udisks2-qt5
, gio-qt
, freeimage
, ffmpeg
, ffmpegthumbnailer
}:

stdenv.mkDerivation rec {
  pname = "deepin-album";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-kRQiH6LvXDpQOgBQiFHM+YQzQFSupOj98aEPbcUumZ8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dtkdeclarative
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    udisks2-qt5
    gio-qt
    freeimage
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
