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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0jg7sfhdm5xsahzcw8hc2vpp5p3sqzdqwp4my65nj85i7wzgxmva";
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
