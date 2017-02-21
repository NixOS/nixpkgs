{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-config";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0mqvv93djsw49n0gxpws3hrwimnyf9kzvc2vhjkzrjfxpabk2axx";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    kde5.libkscreen
    lxqt.liblxqt
    lxqt.libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libXScrnSaver
    xorg.libxcb
    xorg.libXcursor
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = lxqt.standardPatch;

  meta = with stdenv.lib; {
    description = "Tools to configure LXQt and the underlying operating system";
    homepage = https://github.com/lxde/lxqt-config;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
