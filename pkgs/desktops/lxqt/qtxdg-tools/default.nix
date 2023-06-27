{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, libqtxdg
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "qtxdg-tools";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "sha256-iUvjLZbTDBsQw7PIA0LUAvhoq6FrdbLhjbMwKdE01Hc=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    libqtxdg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qtxdg-tools";
    description = "libqtxdg user tools";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
