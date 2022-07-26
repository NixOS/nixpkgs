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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "+FpJD5PEH2/HOSWDQEwMX2sV2JJH0kjcoohBolhSP1A=";
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
    homepage = "https://github.com/lxqt/lxqt-powermanagement";
    description = "Power management module for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
