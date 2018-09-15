{
  stdenv, fetchFromGitHub,
  cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, libdbusmenu, kwindowsystem, solid,
  kguiaddons, liblxqt, libqtxdg, lxqt-globalkeys, libsysstat,
  xorg, libstatgrab, lm_sensors, libpulseaudio, alsaLib, menu-cache,
  lxmenu-data, pcre, libXdamage
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-panel";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "056khr3smyrdi26zpclwv1qrmk0zxr9cnk65ad9c0xavzk6ya3xz";
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
    libdbusmenu
    kwindowsystem
    solid
    kguiaddons
    liblxqt
    libqtxdg
    lxqt-globalkeys
    libsysstat
    xorg.libpthreadstubs
    xorg.libXdmcp
    libstatgrab
    lm_sensors
    libpulseaudio
    alsaLib
    menu-cache
    lxmenu-data
    pcre
    libXdamage
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    for dir in  autostart menu; do
      substituteInPlace $dir/CMakeLists.txt \
        --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
    done
    substituteInPlace panel/CMakeLists.txt \
      --replace "DESTINATION \''${LXQT_ETC_XDG_DIR}" "DESTINATION etc/xdg"
  '';

  meta = with stdenv.lib; {
    description = "The LXQt desktop panel";
    homepage = https://github.com/lxqt/lxqt-panel;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
