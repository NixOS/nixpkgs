{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, qtbase
, qttools
, qtsvg
, kwindowsystem
, liblxqt
, libqtxdg
, lxqt-globalkeys
, qtx11extras
, menu-cache
, muparser
, pcre
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-runner";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1x6s4k27cvj2k51hwpcp3l686c2am504ckry4fm76h0mlnkffjm5";
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
    lxqt-globalkeys
    menu-cache
    muparser
    pcre
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Tool used to launch programs quickly by typing their names";
    homepage = "https://github.com/lxqt/lxqt-runner";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
