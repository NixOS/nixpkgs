{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, solid, kidletime, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-powermanagement";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1fxklxmvjaykdpf0nj6cpgwx4yf52087g25k1zdak9n0l9n7hm8d";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    solid
    kidletime
    liblxqt
    libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
  '';

  meta = with stdenv.lib; {
    description = "Power management module for LXQt";
    homepage = https://github.com/lxde/lxqt-powermanagement;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
