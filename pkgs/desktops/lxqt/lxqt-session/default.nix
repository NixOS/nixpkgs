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
, xorg
, xdg-user-dirs
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-session";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1lmj0cx4crdjl2qih3scm2gvsx3qna0nb6mjjrcx0f2k7h744pik";
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
