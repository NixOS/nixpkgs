{
  stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, polkit-qt, kwindowsystem, liblxqt,
  libqtxdg, pcre
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-policykit";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1hxz5bxxi118g255aqb3da767va0wd25y671lk2w9r1641j8zf2d";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    polkit-qt
    kwindowsystem
    liblxqt
    libqtxdg
    pcre
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
  '';

  meta = with stdenv.lib; {
    description = "The LXQt PolicyKit agent";
    homepage = https://github.com/lxde/lxqt-policykit;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
