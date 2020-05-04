{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, qtx11extras
, kwindowsystem
, liblxqt
, libqtxdg
, xorg
, xdg-user-dirs
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-session";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0kbk13dpmr75yd905n30k51cl7srrxz31ma4kacx450qgr5rwawn";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "An alternative session manager ported from the original razor-session";
    homepage = "https://github.com/lxqt/lxqt-session";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
