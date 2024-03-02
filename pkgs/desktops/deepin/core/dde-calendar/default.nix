{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, qtbase
, qtsvg
, libical
, sqlite
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "dde-calendar";
  version = "5.11.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-EQcB+a0dK2c6NdvGFbyp65a8nN2PmOpZLWx61UDOTJg=";
  };

  patches = [
    ./fix-wrapped-name-not-in-whitelist.diff
  ];

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
    homepage = "https://github.com/linuxdeepin/dde-calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

