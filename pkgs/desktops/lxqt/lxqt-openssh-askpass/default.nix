{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-openssh-askpass";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "19djmqwk4kj3rxs4h7a471ydcz87j5z4yv8a6pgblvqdkkn0ylk9";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI to query passwords on behalf of SSH agents";
    homepage = https://github.com/lxqt/lxqt-openssh-askpass;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
