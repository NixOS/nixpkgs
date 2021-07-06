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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0fihhnb7vp6x072spg1fnxaip4sq9mbvhrfqdwnzph5dlyvs54nj";
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
    homepage = "https://github.com/lxqt/qps";
    description = "Qt based process manager";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux; # does not build on darwin
    maintainers = with maintainers; [ romildo ];
  };
}
