{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg, xdg-user-dirs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-session";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "14ahgix5jsv7fkmvz1imw9a12ygxccqrdxp9yfbpin1az9q1n1qv";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.lxqt-common
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "An alternative session manager ported from the original razor-session";
    homepage = https://github.com/lxde/lxqt-session;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
