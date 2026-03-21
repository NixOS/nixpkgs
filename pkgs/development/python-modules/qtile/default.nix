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
  pyxdg,
  setuptools,
  setuptools-scm,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  libxcb-cursor,
  libxcb-wm,
  xcffib,
  nixosTests,
  extraPackages ? [ ],
}:

buildPythonPackage (finalAttrs: {
  pname = "qtile";
  version = "0.35.0";
  # nixpkgs-update: no auto update
  # should be updated alongside with `qtile-extras`

  pyproject = true;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5XHzlS/Knw/VmVtnM7wToJ/F12GAa2lwdWuXBJHXnZM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];
  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  env = {
    "QTILE_CAIRO_PATH" = "${lib.getDev cairo}/include/cairo";
    "QTILE_PIXMAN_PATH" = "${lib.getDev pixman}/include/pixman-1";
    "QTILE_LIBDRM_PATH" = "${lib.getDev libdrm}/include/libdrm";
    "QTILE_WLROOTS_PATH" =
      "${lib.getDev wlroots}/include/wlroots-${lib.versions.majorMinor wlroots.version}";
  };

  pypaBuildFlags = [
    "--config-setting=backend=wayland"
    "--config-setting=GOBJECT=${lib.getLib glib}/lib/libgobject-2.0.so"
    "--config-setting=PANGO=${lib.getLib pango}/lib/libpango-1.0.so"
    "--config-setting=PANGOCAIRO=${lib.getLib pango}/lib/libpangocairo-1.0.so"
    "--config-setting=XCBCURSOR=${lib.getLib libxcb-cursor}/lib/libxcb-cursor.so"
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
    pyxdg
    xcffib
  ];

  buildInputs = [
    cairo
    libinput
    libxkbcommon
    wayland
    wlroots
    libxcb-wm
  ];

  propagatedBuildInputs = [
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
      doronbehar
    ];
  };
})
