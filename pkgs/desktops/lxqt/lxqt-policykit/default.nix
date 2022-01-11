{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, polkit
, polkit-qt
, kwindowsystem
, liblxqt
, libqtxdg
, pcre
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-policykit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0hmxzkkggnpci305xax9663cbjqdh6n0j0dawwcpwj4ks8mp7xh7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    polkit
    polkit-qt
    kwindowsystem
    liblxqt
    libqtxdg
    pcre
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-policykit";
    description = "The LXQt PolicyKit agent";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
