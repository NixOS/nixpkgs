{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  python3,
  dtkcore,
}:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-B9SrApvjTIW2g9VayrmCsWXS9Gkg55Voi1kPP+KYp3s=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    python3
  ];

  buildInputs = [
    libsForQt5.qtbase
    dtkcore
  ];

  qmakeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
    "LIB_INSTALL_DIR=${placeholder "out"}/lib"
  ];

  postPatch = ''
    substituteInPlace libdframeworkdbus/libdframeworkdbus.pro \
      --replace-fail "/usr" ""
    substituteInPlace libdframeworkdbus/DFrameworkdbusConfig.in \
      --replace-fail "/usr/include" "$out/include"
  '';

  meta = {
    description = "Repo of auto-generated D-Bus source code which DDE used";
    homepage = "https://github.com/linuxdeepin/dde-qt-dbus-factory";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
