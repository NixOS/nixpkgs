{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, json-glib, libfm-qt, qtbase, qttools, qtx11extras }:

mkDerivation rec {
  # pname = "lxqt-archiver";
  pname = "lxqt-archiver-unstable";
  version = "2019-09-25";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = "62501255434b2ba6a8fd043a5af13dc0df038a5b";
    sha256 = "1af58k68karmnay7xgngzlmcgkmvx6hay5m1xbl5id9hh16n20in";
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
