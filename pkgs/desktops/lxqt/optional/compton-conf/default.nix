{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, lxqt, libconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "compton-conf";
  version = "0.2.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1hmirhsz010h6a6k7my1krh5nw5ds4x00c5fq6apamrdd8d4zrmq";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    libconfig
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI configuration tool for compton X composite manager";
    homepage = https://github.com/lxde/compton-conf;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
