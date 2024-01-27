{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qttools
, gitUpdater
}:

mkDerivation rec {
  pname = "qlipper";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = version;
    hash = "sha256-wHhaRtNiNCk5dtO2dVjRFDVicmYtrnCb2twx6h1m834=";
  };

  nativeBuildInputs = [
    cmake
    qttools
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Cross-platform clipboard history applet";
    homepage = "https://github.com/pvanek/qlipper";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
