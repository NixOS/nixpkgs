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

stdenv.mkDerivation (finalAttrs: {
  pname = "libsysstat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libsysstat";
    rev = finalAttrs.version;
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

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
})
