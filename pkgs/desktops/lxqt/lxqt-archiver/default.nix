{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, json-glib, libfm-qt, qtbase, qttools, qtx11extras }:

mkDerivation rec {
  # pname = "lxqt-archiver";
  pname = "lxqt-archiver-unstable";
  version = "2019-09-15";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = "1e657b6a3e68c32f042d583872eca39a5d4b820f";
    sha256 = "1vc9pzxrhznp65gdkzj3fzzivfqy712mwcxp3r25ar59d54alfpj";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    json-glib
    libfm-qt
    qtbase
    qttools
    qtx11extras
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Archive tool for the LXQt desktop environment";
    homepage = https://github.com/lxqt/lxqt-archiver/;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ];
  };
}
