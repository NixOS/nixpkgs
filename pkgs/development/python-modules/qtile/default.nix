{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cairocffi,
  dbus-fast,
  aiohttp,
  cairo,
  cffi,
  glib,
  iwlib,
  libcst,
  libdrm,
  libinput,
  libxkbcommon,
  mpd2,
  pango,
  pixman,
  pkg-config,
  psutil,
  pulsectl-asyncio,
  pygobject3,
  pytz,
  pywayland,
  pywlroots,
  pyxdg,
  setuptools,
  setuptools-scm,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  xcbutilcursor,
  xcbutilwm,
  xcffib,
  xkbcommon,
  nixosTests,
  extraPackages ? [ ],
}:

buildPythonPackage rec {
  pname = "qtile";
  version = "0.34.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    tag = "v${version}";
    hash = "sha256-PPyI+IGvHBQusVmU3D26VjYjLaa9+94KUqNwbQSzeaI=";
  };

  build-system = [
    setuptools
    setuptools-scm
    pkg-config
  ];

  env = {
    "QTILE_CAIRO_PATH" = "${lib.getDev cairo}/include/cairo";
    "QTILE_PIXMAN_PATH" = "${lib.getDev pixman}/include/pixman-1";
    "QTILE_LIBDRM_PATH" = "${lib.getDev libdrm}/include/libdrm";
    "QTILE_WLROOTS_PATH" = "${lib.getDev wlroots}/include/wlroots-0.19";
  };

  pypaBuildFlags = [
    "--config-setting=backend=wayland"
    "--config-setting=GOBJECT=${lib.getLib glib}/lib/libgobject-2.0.so"
    "--config-setting=PANGO=${lib.getLib pango}/lib/libpango-1.0.so"
    "--config-setting=PANGOCAIRO=${lib.getLib pango}/lib/libpangocairo-1.0.so"
    "--config-setting=XCBCURSOR=${lib.getLib xcbutilcursor}/lib/libxcb-cursor.so"
  ];

  dependencies = extraPackages ++ [
    (cairocffi.override { withXcffib = true; })
    dbus-fast
    iwlib
    libcst
    mpd2
    psutil
    pulsectl-asyncio
    pygobject3
    pytz
    pywayland
    pywlroots
    pyxdg
    xcffib
    xkbcommon
  ];

  buildInputs = [
    cairo
    libinput
    libxkbcommon
    wayland
    wlroots
    xcbutilwm
  ];

  propagatedBuildInputs = [
    wayland-scanner
    wayland-protocols
    cffi
    xcffib
    aiohttp
  ];

  doCheck = false;
  passthru = {
    tests.qtile = nixosTests.qtile;
    providedSessions = [ "qtile" ];
  };

  postInstall = ''
    install resources/qtile.desktop -Dt $out/share/xsessions
    install resources/qtile-wayland.desktop -Dt $out/share/wayland-sessions
  '';

  meta = {
    homepage = "http://www.qtile.org/";
    license = lib.licenses.mit;
    description = "Small, flexible, scriptable tiling window manager written in Python";
    mainProgram = "qtile";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      arjan-s
      sigmanificient
    ];
  };
}
