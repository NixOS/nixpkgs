{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, qtbase
, qttools
, lxqt
, libconfig
}:

mkDerivation rec {
  pname = "compton-conf";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0gcvyn7aabdz5yj0jzv14hlgjgbm8d9ib5r73i842f0hv4cv9m0q";
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

  passthru.updateScript = lxqt.lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "GUI configuration tool for compton X composite manager";
    homepage = "https://github.com/lxqt/compton-conf";
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
