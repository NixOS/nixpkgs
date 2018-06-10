{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, lxqt-globalkeys, qtx11extras,
menu-cache, muparser, pcre }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-runner";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1354vdaskhch1n8v3kdy15nszgqb1092csr84nbhymzgrhrq1093";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    lxqt-globalkeys
    menu-cache
    muparser
    pcre
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
  '';

  meta = with stdenv.lib; {
    description = "Tool used to launch programs quickly by typing their names";
    homepage = https://github.com/lxde/lxqt-runner;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
