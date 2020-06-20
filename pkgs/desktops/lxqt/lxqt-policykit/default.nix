{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, polkit-qt
, kwindowsystem
, liblxqt
, libqtxdg
, pcre
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-policykit";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "001zgjxgvzp7clfqr46sx8m3a7v38xxgxjqrpz01lxx18zik3d9h";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    polkit-qt
    kwindowsystem
    liblxqt
    libqtxdg
    pcre
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "The LXQt PolicyKit agent";
    homepage = "https://github.com/lxqt/lxqt-policykit";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
