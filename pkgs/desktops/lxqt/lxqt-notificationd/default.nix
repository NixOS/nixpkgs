{ lib, mkDerivation, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, qtx11extras }:

mkDerivation rec {
  pname = "lxqt-notificationd";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1ihaf2i361j2snyy6kg8ccpfnc8hppvacmxjqzb1lpyaf1ajd139";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    qtx11extras
  ];

  meta = with lib; {
    description = "The LXQt notification daemon";
    homepage = https://github.com/lxqt/lxqt-notificationd;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
