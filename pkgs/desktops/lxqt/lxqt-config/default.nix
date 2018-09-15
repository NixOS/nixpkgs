{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qtx11extras, qttools, qtsvg, kwindowsystem, libkscreen, liblxqt, libqtxdg, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-config";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0r5vwkyz0c9b9py3wni4yzkmsvgs6psk9dp1fhfzvbjbknb21bfa";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    libkscreen
    liblxqt
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libXScrnSaver
    xorg.libxcb
    xorg.libXcursor
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
  '';

  meta = with stdenv.lib; {
    description = "Tools to configure LXQt and the underlying operating system";
    homepage = https://github.com/lxqt/lxqt-config;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };

}
