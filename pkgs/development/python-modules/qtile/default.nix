{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  pkg-config,
  wayland-scanner,

  # dependencies
  cairocffi,
  dbus-fast,
  iwlib,
  libcst,
  mpd2,
  psutil,
  pulsectl-asyncio,
  pygobject3,
  pytz,
  pyxdg,
  xcffib,
  extraPackages ? [ ],

  # buildInputs
  cairo,
  libinput,
  libxcb-wm,
  libxkbcommon,
  wayland,
  wlroots,
  # environment & pypaBuildFlags
  libdrm,
  pixman,
  glib,
  pango,
  libxcb-cursor,

  # propagatedBuildInputs
  aiohttp,
  cffi,
  wayland-protocols,

  # checkInputs
  gtk3,
  librsvg,

  # nativeCheckInputs
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpbin,
  pytest-xdist,
  writableTmpDirAsHomeHook,
  anyio,
  fontconfig,
  gdk-pixbuf,
  gobject-introspection,
  isort,
  wxsvg,
  xorg-server,
  xterm,
  xvfb,

  # passthru.tests
  nixosTests,
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

  patches = [
    # https://github.com/qtile/qtile/pull/5889
    ./fix-test-net.patch
  ];

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
    aiohttp
    (cairocffi.override { withXcffib = true; })
    cffi
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
    libxcb-wm
    libxkbcommon
    wayland
    wlroots
  ];

  propagatedBuildInputs = [
    wayland-protocols
  ];

  pythonImportsCheck = [ "libqtile" ];

  checkInputs = [
    gtk3
    librsvg
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpbin
    pytest-xdist
    writableTmpDirAsHomeHook
    anyio
    fontconfig
    gdk-pixbuf
    gobject-introspection
    isort
    wxsvg
    xorg-server
    xterm
    xvfb
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  disabledTests = [
    # ModuleNotFoundError: No module named 'libqtile'
    # known issue upstream: https://github.com/qtile/qtile/issues/5883
    "test_identify_output"

    # caused by dbus-fast trying to read '/var/lib/dbus/machine-id'
    "test_defaults"
    "test_device_actions"
    "test_adapter_actions"
    "test_statusnotifier_defaults"
    "test_custom_symbols"
    "test_statusnotifier_defaults_vertical_bar"
    "test_default_show_battery"
    "test_statusnotifier_icon_size"
    "test_missing_adapter"
    "test_statusnotifier_left_click"
    "test_default_text"
    "test_statusnotifier_left_click_vertical_bar"
    "test_default_device"

    # PermissionError: [Errno 13] Permission denied: '/var'
    "test_thermal_zone_getting_value"

    # Probably won't work in the Nix sandbox due to `xcffib.ConnectionException`
    "test_urgent_hook_fire"
  ];

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
