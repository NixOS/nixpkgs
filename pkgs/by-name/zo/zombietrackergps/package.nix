{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  libsForQt5,
}:
stdenv.mkDerivation {
  pname = "zombietrackergps";
  version = "1.15";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = "zombietrackergps";
    # latest revision is not tagged upstream, use commit sha in the meantime
    #rev = "v_${version}";
    rev = "cc75d5744965cc6973323f5bb77f00b0b0153dce";
    hash = "sha256-z/LFNRFdQQFxEWyAjcuGezRbTsv8z6Q6fK8NLjP4HNM=";
  };

  buildInputs = with libsForQt5; [
    marble.dev
    qtbase
    qtcharts
    qtsvg
    qtwebengine
    ldutils
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  preConfigure = ''
    export LANG=en_US.UTF-8
  '';

  cmakeFlags = [
    "-DLDUTILS_ROOT=${libsForQt5.ldutils}"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v_";
  };

  meta = {
    description = "GPS track manager for Qt using KDE Marble maps";
    homepage = "https://www.zombietrackergps.net/ztgps/";
    changelog = "https://www.zombietrackergps.net/ztgps/history.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sohalt ];
    platforms = lib.platforms.linux;
  };
}
