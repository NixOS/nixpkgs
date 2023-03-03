{ stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qtbase
, qtx11extras
, wrapQtAppsHook
, mtdev
, cairo
, xorg
, waylandSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-AySltMI9x5mfquy532h1QfGpfwSfI9+h6BtIHPyNWGk=";
  };

  ## https://github.com/linuxdeepin/qt5platform-plugins/pull/119
  postPatch = ''
    rm -r xcb/libqt5xcbqpa-dev/
    mkdir -p xcb/libqt5xcbqpa-dev/${qtbase.version}
    cp -r ${qtbase.src}/src/plugins/platforms/xcb/*.h xcb/libqt5xcbqpa-dev/${qtbase.version}/
  '';

  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];

  buildInputs = [
    mtdev
    cairo
    qtbase
    qtx11extras
    xorg.libSM
  ];

  qmakeFlags = [
    "INSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
  ]
  ++ lib.optional (!waylandSupport) [ "CONFIG+=DISABLE_WAYLAND" ];

  meta = with lib; {
    description = "Qt platform plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5platform-plugins";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
