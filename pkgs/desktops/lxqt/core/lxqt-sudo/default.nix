{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg, sudo }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-sudo";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0ql436yb51qwbnj5gbzvqi4rqx4zkmja5rdjs6yavb1x8ggn1jv6";
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
    sudo
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI frontend for sudo/su";
    homepage = https://github.com/lxde/lxqt-sudo;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
