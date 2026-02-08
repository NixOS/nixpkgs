{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  kwindowsystem,
  libxscrnsaver,
  libxcursor,
  libxdmcp,
  libkscreen,
  liblxqt,
  libpthread-stubs,
  libqtxdg,
  libxcb,
  lxqt-build-tools,
  lxqt-menu-data,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  xf86-input-libinput,
  xkeyboard_config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-config";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-config";
    rev = version;
    hash = "sha256-2CAQeX2X0DPmgOaAEJoCLtgjFT+Z6epc/dUCbaEIlB0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    glib.bin
    kwindowsystem
    libxscrnsaver
    libxcursor
    libxdmcp
    libkscreen
    liblxqt
    libpthread-stubs
    libqtxdg
    libxcb
    lxqt-menu-data
    qtbase
    qtsvg
    qtwayland
    xf86-input-libinput
    xf86-input-libinput.dev
  ];

  cmakeFlags = [ "-DCMAKE_CXX_STANDARD=20" ];

  postPatch = ''
    substituteInPlace lxqt-config-appearance/configothertoolkits.cpp \
      --replace-fail 'QStringLiteral("gsettings' \
                'QStringLiteral("${glib.bin}/bin/gsettings'

    substituteInPlace lxqt-config-input/keyboardlayoutconfig.h \
      --replace-fail '/usr/share/X11/xkb/rules/base.lst' \
                '${xkeyboard_config}/share/X11/xkb/rules/base.lst'
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-config";
    description = "Tools to configure LXQt and the underlying operating system";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };

}
