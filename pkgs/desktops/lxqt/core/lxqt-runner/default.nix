{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt,
menu-cache, muparser }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-runner";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1gqs1b90km39dbg49g80x770i9jknni4h8y6ka2r1fga35amllkc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.lxqt-globalkeys
    menu-cache
    muparser
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Tool used to launch programs quickly by typing their names";
    homepage = https://github.com/lxde/lxqt-runner;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
