{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, lxqt, libconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "compton-conf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1p1y7g5psczx1dgh6gd1h5iga8rylvczkwlfirzrh0rfl45dajgb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    libconfig
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  preConfigure = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg" \
    '';

  meta = with stdenv.lib; {
    description = "GUI configuration tool for compton X composite manager";
    homepage = https://github.com/lxde/compton-conf;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
