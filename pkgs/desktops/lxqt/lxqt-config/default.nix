{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  kwindowsystem,
  libXScrnSaver,
  libXcursor,
  libXdmcp,
  libkscreen,
  liblxqt,
  libpthreadstubs,
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
  xf86inputlibinput,
  xkeyboard_config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-config";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-lFZTu6MqqWTjytYC7In/YJ38PYksZXduHvA/FRY4v0U=";
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
    libXScrnSaver
    libXcursor
    libXdmcp
    libkscreen
    liblxqt
    libpthreadstubs
    libqtxdg
    libxcb
    lxqt-menu-data
    qtbase
    qtsvg
    qtwayland
    xf86inputlibinput
    xf86inputlibinput.dev
  ];

  postPatch = ''
    substituteInPlace lxqt-config-appearance/configothertoolkits.cpp \
      --replace-fail 'QStringLiteral("gsettings' \
                'QStringLiteral("${glib.bin}/bin/gsettings'

    substituteInPlace lxqt-config-input/keyboardlayoutconfig.h \
      --replace-fail '/usr/share/X11/xkb/rules/base.lst' \
                '${xkeyboard_config}/share/X11/xkb/rules/base.lst'
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-config";
    description = "Tools to configure LXQt and the underlying operating system";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };

}
