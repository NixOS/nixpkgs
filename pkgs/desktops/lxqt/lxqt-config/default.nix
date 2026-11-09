{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-config";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-config";
    tag = finalAttrs.version;
    hash = "sha256-BG3+/QZkqCZp7kdaHgiruOMq506l8+9KKNq+IUgoTPw=";
  };

  # Remove when updating to a release containing upstream commit 8efdae2.
  patches = [
    (fetchpatch2 {
      name = "fix-kscreen-build.patch";
      url = "https://github.com/lxqt/lxqt-config/commit/8efdae223bbea13a653d66a1bca6004df77d7033.patch?full_index=1";
      hash = "sha256-VJ4uZme4j49VKIyr87NX9z0enJwVdoK1dpXsuIFQ5jo=";
    })
  ];

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

})
