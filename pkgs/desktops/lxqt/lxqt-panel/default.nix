{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, kguiaddons
, kwindowsystem
, libXdamage
, libdbusmenu
, liblxqt
, libpulseaudio
, libqtxdg
, libstatgrab
, libsysstat
, lm_sensors
, lxmenu-data
, lxqt-build-tools
, lxqt-globalkeys
, lxqtUpdateScript
, menu-cache
, pcre
, qtbase
, qtsvg
, qttools
, qtx11extras
, solid
, xorg
}:

mkDerivation rec {
  pname = "lxqt-panel";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0i63jyjg31336davjdak7z3as34gazx1lri65fk2f07kka9dx1jl";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    alsa-lib
    kguiaddons
    kwindowsystem
    libXdamage
    libdbusmenu
    liblxqt
    libpulseaudio
    libqtxdg
    libstatgrab
    libsysstat
    lm_sensors
    lxmenu-data
    lxqt-globalkeys
    menu-cache
    pcre
    qtbase
    qtsvg
    qttools
    qtx11extras
    solid
    xorg.libXdmcp
    xorg.libpthreadstubs
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-panel";
    description = "The LXQt desktop panel";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
