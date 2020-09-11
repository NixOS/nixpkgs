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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    sha256 = "1cip2dbvxbdlx1axz5sn4mwigwvfxb1q14byn09crv71adyfprw5";
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
