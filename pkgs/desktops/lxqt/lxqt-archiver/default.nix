{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, json-glib, libfm-qt, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-archiver";
  version = "0.0.96";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
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

  meta = with stdenv.lib; {
    description = "Archive tool for the LXQt desktop environment";
    homepage = https://github.com/lxqt/lxqt-archiver/;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ];
  };
}
