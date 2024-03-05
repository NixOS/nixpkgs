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
, dde-qt-dbus-factory
, kcodecs
, syntax-highlighting
, libchardet
, libuchardet
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "deepin-editor";
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-17loD7FNy5PwSxIyXk313yiMxO10rOeP94q08tm76gw=";
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

  meta = with lib; {
    description = "A desktop text editor that supports common text editing features";
    homepage = "https://github.com/linuxdeepin/deepin-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
