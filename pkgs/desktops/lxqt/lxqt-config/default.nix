{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, glib
, lxqt-build-tools
, qtbase
, qtx11extras
, qttools
, qtsvg
, kwindowsystem
, libkscreen
, liblxqt
, libqtxdg
, xkeyboard_config
, xorg
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-config";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "WgrcHM4iJLZsJO2obqSkjHHMB+/kcadQArkcXC5FB24=";
  };

  patches = [
    # FIXME: backport Plasma 5.27 build fix, remove for next release
    (fetchpatch {
      url = "https://github.com/lxqt/lxqt-config/commit/6add4e4f0040693e7c4242fbae48c9d32007686c.diff";
      hash = "sha256-Tir4KeGhBnD9dYmB1FAjuf4R4V+rn12MOxsRwTdE0Sc=";
    })
  ];

  # FIXME: required to build with Plasma 5.27, which uses std::optional
  cmakeFlags = ["-DCMAKE_CXX_STANDARD=17"];

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    glib.bin
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
    substituteInPlace lxqt-config-appearance/configothertoolkits.cpp \
      --replace 'QStringLiteral("gsettings' \
                'QStringLiteral("${glib.bin}/bin/gsettings'

    substituteInPlace lxqt-config-input/keyboardlayoutconfig.h \
      --replace '/usr/share/X11/xkb/rules/base.lst' \
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
