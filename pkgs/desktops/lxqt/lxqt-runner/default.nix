{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, lxqt-globalkeys, qtx11extras,
menu-cache, muparser, pcre }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-runner";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0w6r9lby35p0lf5klasa5l2lscx6dmv16kzfhl4lc6w2qfwjb9vi";
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
    homepage = https://github.com/lxqt/lxqt-runner;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
