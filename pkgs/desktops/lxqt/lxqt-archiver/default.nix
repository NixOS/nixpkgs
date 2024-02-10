{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, json-glib
, libexif
, libfm-qt
, menu-cache
, qtbase
, qttools
, qtx11extras
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-archiver";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    hash = "sha256-8pfUpyjn01D8CL+2PjGkZqyHu+lpHZIXlXn67rZoxMY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    json-glib
    libexif
    libfm-qt
    menu-cache
    qtbase
    qtx11extras
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ] ++ teams.lxqt.members;
  };
}
