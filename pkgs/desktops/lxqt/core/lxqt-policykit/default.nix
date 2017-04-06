{
  stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, polkit-qt, kwindowsystem, liblxqt,
  libqtxdg,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-policykit";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0sf8wj152z1xid1i2x5g1zpgh7lwq8f0rbrk3r9shyksxqcj2d8p";
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
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The LXQt PolicyKit agent";
    homepage = https://github.com/lxde/lxqt-policykit;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
