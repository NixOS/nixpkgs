{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase,
  qtx11extras, qttools, qtsvg, kwindowsystem, libkscreen, liblxqt,
  libqtxdg, xorg }:

stdenv.mkDerivation rec {
  pname = "lxqt-config";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1pp2pw43zh8kwi2cxk909wn6bw7kba95b6bv96l2gmzhdqpfw2a7";
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
    substituteInPlace src/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"

    for f in \
      lxqt-config-file-associations/CMakeLists.txt \
      lxqt-config-brightness/CMakeLists.txt \
      lxqt-config-appearance/CMakeLists.txt \
      lxqt-config-locale/CMakeLists.txt \
      lxqt-config-monitor/CMakeLists.txt \
      lxqt-config-input/CMakeLists.txt \
      liblxqt-config-cursor/CMakeLists.txt \
      src/CMakeLists.txt
    do
      substituteInPlace $f \
        --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
    done

    sed -i "/\''${XORG_LIBINPUT_INCLUDE_DIRS}/a ${xorg.xf86inputlibinput.dev}/include/xorg" lxqt-config-input/CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "Tools to configure LXQt and the underlying operating system";
    homepage = https://github.com/lxqt/lxqt-config;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };

}
