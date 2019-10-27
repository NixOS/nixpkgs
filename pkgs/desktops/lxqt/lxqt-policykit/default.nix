{
  lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, polkit-qt, kwindowsystem, liblxqt,
  libqtxdg, pcre
}:

mkDerivation rec {
  pname = "lxqt-policykit";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0mh9jw09r0mk8xmgvmzk3yyfix0pzqya28rcx71fqjpbdv1sc44l";
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

  meta = with lib; {
    description = "The LXQt PolicyKit agent";
    homepage = https://github.com/lxqt/lxqt-policykit;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
