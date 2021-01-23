{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-build-tools
, lxqtUpdateScript
, qtbase
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "qps";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0gfw7iz7jzyfl9hiq3aivbgkkl61fz319cfg57fgn2kldlcljhwa";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qttools
    qtx11extras
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Qt based process manager";
    homepage = "https://github.com/lxqt/qps";
    license = licenses.gpl2;
    platforms = with platforms; linux; # does not build on darwin
    maintainers = with maintainers; [ romildo ];
  };
}
