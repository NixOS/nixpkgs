{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, qtbase
, qtx11extras
, qttools
, qtsvg
, kwindowsystem
, libkscreen
, liblxqt
, libqtxdg
, xorg
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-config";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1ppkkz7rg5ddlyk1ikh2s3g7nbb0wnpl0lldg9j68l76d61sfm8z";
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
    xorg.xf86inputlibinput
    xorg.xf86inputlibinput.dev
  ];

  postPatch = ''
    sed -i "/\''${XORG_LIBINPUT_INCLUDE_DIRS}/a ${xorg.xf86inputlibinput.dev}/include/xorg" lxqt-config-input/CMakeLists.txt
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Tools to configure LXQt and the underlying operating system";
    homepage = "https://github.com/lxqt/lxqt-config";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };

}
