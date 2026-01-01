{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-notificationd";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-notificationd";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-TfTOuarMq2m5rAdcfiKqjyGeJzKyUSvhkJ2EoGUMTUQ=";
=======
    hash = "sha256-VmPVGqCmkTkib2T5ysov1hUY3J74GTuXdJsn5Sivreo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "LXQt notification daemon";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
=======
  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-notificationd";
    description = "LXQt notification daemon";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
