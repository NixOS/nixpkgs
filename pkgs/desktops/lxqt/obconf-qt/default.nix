{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, qtbase
, qttools
, qtx11extras
, xorg
, lxqt-build-tools
, openbox
, gitUpdater
}:

mkDerivation rec {
  pname = "obconf-qt";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-ExBcP+j1uf9Y8f6YfZsqyD6YTx1PriS3w8I6qdqQGeE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    pcre
    qtbase
    qtx11extras
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libSM
    openbox
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/obconf-qt";
    description = "The Qt port of obconf, the Openbox configuration tool";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
