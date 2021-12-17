{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, qtx11extras
, kwindowsystem
, liblxqt
, libqtxdg
, procps
, xorg
, xdg-user-dirs
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-session";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0g355dmlyz8iljw953gp5jqlz02abd1ksssah826hxcy4j89mk7s";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    procps
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-session";
    description = "An alternative session manager ported from the original razor-session";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
