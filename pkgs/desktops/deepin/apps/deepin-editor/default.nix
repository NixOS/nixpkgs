{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  qtbase,
  qtsvg,
  dde-qt-dbus-factory,
  kcodecs,
  syntax-highlighting,
  libchardet,
  libuchardet,
  libiconv,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "deepin-editor";
  version = "6.0.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-55hRXHP02MJWt+JUDCDKv4Boq0IwNW1itGw9rtCZrao=";
  };

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
    dde-qt-dbus-factory
    kcodecs
    syntax-highlighting
    libchardet
    libuchardet
    libiconv
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A desktop text editor that supports common text editing features";
    homepage = "https://github.com/linuxdeepin/deepin-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
