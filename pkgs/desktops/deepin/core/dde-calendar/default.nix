{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qttools,
  pkg-config,
  wrapQtAppsHook,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dde-qt-dbus-factory,
  qtbase,
  qtsvg,
  libical,
  sqlite,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "dde-calendar";
  version = "5.14.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-08xkdiP0/haHY3jdHSoA1zXRxMi2t+qxLxbcRc7EO6Q=";
  };

  patches = [ ./fix-wrapped-name-not-in-whitelist.diff ];

  postPatch = ''
    for file in $(grep -rl "/bin/bash"); do
      substituteInPlace $file --replace "/bin/bash" "${runtimeShell}"
    done
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qt5integration
    qt5platform-plugins
    dtkwidget
    qtbase
    qtsvg
    dde-qt-dbus-factory
    libical
    sqlite
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = with lib; {
    description = "Calendar for Deepin Desktop Environment";
    mainProgram = "dde-calendar";
    homepage = "https://github.com/linuxdeepin/dde-calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
