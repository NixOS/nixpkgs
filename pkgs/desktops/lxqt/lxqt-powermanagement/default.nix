{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, kwindowsystem
, solid
, kidletime
, liblxqt
, libqtxdg
, lxqt-globalkeys
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-powermanagement";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1pf3z8hymddk1cm5j5lqgah967xsdl37j66gz5bs3dw7871gbdhy";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    solid
    kidletime
    liblxqt
    libqtxdg
    lxqt-globalkeys
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Power management module for LXQt";
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
