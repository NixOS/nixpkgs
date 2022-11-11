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
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "sha256-8jrb1Mdn9dhQzIEu6E0kz5F8eEnKAREwjXuypqfhw60=";
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
