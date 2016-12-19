{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-powermanagement";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "10myxrhlhvr9cmcqv67skzd11c40bgqgf6qdvm5smww2il1mzfwa";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    kde5.solid
    kde5.kidletime
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Power management module for LXQt";
    homepage = https://github.com/lxde/lxqt-powermanagement;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
