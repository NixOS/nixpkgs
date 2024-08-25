{
  stdenv,
  lib,
  fetchFromGitHub,
  qmake,
  qtbase,
  wrapQtAppsHook,
  python3,
  dtkcore,
}:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-9r5thJJjEZAuDT0N/m1gcr0Faa8WpZOtGKDYuZEvJis=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    python3
  ];

  buildInputs = [
    qtbase
    dtkcore
  ];

  qmakeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
    "LIB_INSTALL_DIR=${placeholder "out"}/lib"
  ];

  postPatch = ''
    substituteInPlace libdframeworkdbus/libdframeworkdbus.pro \
     --replace "/usr" ""

    substituteInPlace libdframeworkdbus/DFrameworkdbusConfig.in \
      --replace "/usr/include" "$out/include"
  '';

  meta = with lib; {
    description = "Repo of auto-generated D-Bus source code which DDE used";
    homepage = "https://github.com/linuxdeepin/dde-qt-dbus-factory";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
