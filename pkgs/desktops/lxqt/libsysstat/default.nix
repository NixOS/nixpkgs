{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  lxqt-build-tools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libsysstat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libsysstat";
    rev = version;
    hash = "sha256-CwQz0vaBhMe32xBoSgFkxSwx3tnIHutp9Vs32FvTNVU=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
=======
  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
