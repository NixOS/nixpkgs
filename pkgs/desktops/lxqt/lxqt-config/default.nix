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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "Gm/Y/5i7Abob9eRdLZHpRma2+Mdh2LBZUGKM4mMZMFk=";
  };

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
