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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "05qi550cjyjzhlma4zxnp1pn8i5cgak2k2mwwh2a5gpicp5axavn";
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
