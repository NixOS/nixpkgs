{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  dtk6core,
}:

stdenv.mkDerivation rec {
  pname = "dde-application-manager";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-KUwX7oilV562WDxkBhTQhwz2lgcQIYwkmRRglWj0zh8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsNoGuiHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    dtk6core
  ];

  meta = with lib; {
    description = "Application manager for DDE";
    mainProgram = "dde-application-manager";
    homepage = "https://github.com/linuxdeepin/dde-application-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
