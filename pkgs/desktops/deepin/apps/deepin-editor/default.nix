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
}:

stdenv.mkDerivation rec {
  pname = "deepin-editor";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-f6CJlSgsKU311ziXmm7Ado8tH+3dNRpWB1e4TewVf/8=";
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

  meta = {
    description = "Desktop text editor that supports common text editing features";
    homepage = "https://github.com/linuxdeepin/deepin-editor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
