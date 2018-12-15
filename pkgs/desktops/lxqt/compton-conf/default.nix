{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, lxqt, libconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "compton-conf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1r187fx1vivzq1gcwwawax36mnlmfig5j1ba4s4wfdi3q2wcq7mw";
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
    homepage = https://github.com/lxqt/compton-conf;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
