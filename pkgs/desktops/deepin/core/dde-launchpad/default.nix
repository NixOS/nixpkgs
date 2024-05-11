{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qt6Packages
, dtk6declarative
, appstream-qt
, kitemmodels
, dde-shell
}:

stdenv.mkDerivation rec {
  pname = "dde-launchpad";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-MVSWcUqbZDloKKfly+E7HLObpJlj0Oq8G8pP5Lkpriw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    dtk6declarative
    dde-shell
    #kitemmodels
  ] ++ (with qt6Packages ; [
    qtbase
    qtsvg
    qtwayland
    appstream-qt
  ]);

  cmakeFlags = [
    "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user"
  ];

  meta = with lib; {
    description = "The 'launcher' or 'start menu' component for DDE";
    mainProgram = "dde-launchpad";
    homepage = "https://github.com/linuxdeepin/dde-launchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
