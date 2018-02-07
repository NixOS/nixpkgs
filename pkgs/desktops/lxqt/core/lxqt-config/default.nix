{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig, lxqt-build-tools, qtbase, qtx11extras, qttools, qtsvg, kwindowsystem, libkscreen, liblxqt, libqtxdg, libpthreadstubs, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-config";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1ccxkdfhgf40jxiy0132yr9b28skvs9yr8j75w663hnqi6ccn377";
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
    homepage = https://github.com/lxde/lxqt-config;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };

}
