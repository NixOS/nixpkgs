{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg, sudo }:

mkDerivation rec {
  pname = "lxqt-sudo";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1my0wpic20493rdlabp9ghag1g3nhwafk2yklkgczlajmarakgpc";
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
    liblxqt
    libqtxdg
    sudo
  ];

  meta = with lib; {
    description = "GUI frontend for sudo/su";
    homepage = https://github.com/lxqt/lxqt-sudo;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
