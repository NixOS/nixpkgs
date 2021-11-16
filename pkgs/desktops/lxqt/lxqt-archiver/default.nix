{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    sha256 = "033lq7n34a5qk2zv8kr1633p5x2cjimv4w4n86w33xmcwya4yiji";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ];
  };
}
