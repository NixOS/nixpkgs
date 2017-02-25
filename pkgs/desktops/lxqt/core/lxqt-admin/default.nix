{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, standardPatch, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, polkit }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-admin";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "12c1wdciqgiifsk5aslw3990pk9ylk9jhgwnrxvh798rr48hhflr";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    polkit
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = standardPatch;

  meta = with stdenv.lib; {
    description = "LXQt system administration tool";
    homepage = https://github.com/lxde/lxqt-admin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
