{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, standardPatch, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-globalkeys";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1kwibll2azi4pafk7crfgibk5a54rnsia3c4cz680iny7xz1wy6h";
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

  postPatch = standardPatch;

  meta = with stdenv.lib; {
    description = "Daemon used to register global keyboard shortcuts";
    homepage = https://github.com/lxde/lxqt-globalkeys;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
