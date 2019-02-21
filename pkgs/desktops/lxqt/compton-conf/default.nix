{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, lxqt,
  libconfig }:

stdenv.mkDerivation rec {
  pname = "compton-conf";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1vxbh0vr7wknr7rbmdbmy5md1fdkw3zwlgpbv16cwdplbv9m97xi";
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
