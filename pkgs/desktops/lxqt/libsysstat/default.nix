{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, lxqt-build-tools
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libsysstat";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-2rdhw67TPvy/QmyzbtStgiIuIgZ7ZSt07xjCvOywKF4=";
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

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
