{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-lxqt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-PqX8ShSu3CYN9XIRp6IjVmr/eKH+oLNhXvwiudUH660=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Qt implementation of the DBusMenu protocol";
    homepage = "https://github.com/lxqt/libdbusmenu-lxqt";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
}
