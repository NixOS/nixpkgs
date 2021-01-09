{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, json-glib
, libfm-qt
, qtbase
, qttools
, qtx11extras
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-archiver";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    sha256 = "0f4nj598w6qhcrhbab15cpfmrda02jcflxhb15vyv7gnplalkya6";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    json-glib
    libfm-qt
    qtbase
    qttools
    qtx11extras
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Archive tool for the LXQt desktop environment";
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ];
  };
}
