{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  qt6integration,
  qt6platform-plugins,
  dtk6declarative,
  dde-shell,
}:

stdenv.mkDerivation rec {
  pname = "dde-launchpad";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-nT89cUx7Bxf+d+fgqvXZ9U0i/qf1oP2alUB90UXpNcM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs =
    [
      qt6integration
      qt6platform-plugins
      dtk6declarative
      dde-shell
    ]
    ++ (with qt6Packages; [
      qtbase
      qtsvg
      qtwayland
      appstream-qt
    ]);

  cmakeFlags = [ "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user" ];

  meta = with lib; {
    description = "'launcher' or 'start menu' component for DDE";
    mainProgram = "dde-launchpad";
    homepage = "https://github.com/linuxdeepin/dde-launchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
