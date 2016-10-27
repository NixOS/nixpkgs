{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-globalkeys";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "05kcq21fyz7vnhh9k4nzhskgbghp1slsz14gh9anhya4a567xx0y";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = lxqt.standardPatch;

  meta = with stdenv.lib; {
    description = "Daemon used to register global keyboard shortcuts";
    homepage = https://github.com/lxde/lxqt-globalkeys;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
