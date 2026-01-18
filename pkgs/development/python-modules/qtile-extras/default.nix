{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  anyio,
  gobject-introspection,
  gtk3,
  imagemagick,
  keyring,
  librsvg,
  pulseaudio,
  pytest-asyncio,
  pytest-lazy-fixture,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  qtile,
  requests,
  setuptools-scm,
  xorgserver,
  nixosTests,
}:
buildPythonPackage rec {
  pname = "qtile-extras";
  version = "0.34.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elParaguayo";
    repo = "qtile-extras";
    tag = "v${version}";
    hash = "sha256-CtmTZmUQlqkDPd++n3fPbRB4z1NA4ZxnmIR84IjsURw=";
  };

  patches = [
    # Remove unpack of widget.eval call in tests
    # https://github.com/elParaguayo/qtile-extras/pull/460
    (fetchpatch {
      url = "https://github.com/elParaguayo/qtile-extras/commit/359964520a9dcd2c7e12680bfc53e359d74c489b.patch?full_index=1";
      hash = "sha256-nKt39bTaBbvEC5jWU6XH0pigTs4hpSmMIwFe/A9YdJA=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [ gtk3 ];

  nativeCheckInputs = [
    anyio
    gobject-introspection
    imagemagick
    keyring
    pulseaudio
    pytest-asyncio
    pytest-lazy-fixture
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    python-dateutil
    qtile
    requests
    xorgserver
    # stravalib  # marked as broken due to https://github.com/stravalib/stravalib/issues/379
  ];

  disabledTests = [
    # Needs a running DBUS
    "test_brightness_power_saving"
    "test_global_menu"
    "test_mpris2_popup"
    "test_statusnotifier_menu"
    # No network connection
    "test_wifiicon_internet_check"
    # Image difference is outside tolerance
    "test_decoration_output"
    # Needs Github token
    "test_githubnotifications_reload_token"
    # AttributeError: 'NoneType' object has no attribute 'theta'
    "test_image_size_horizontal"
    "test_image_size_vertical"
    # flaky, timing sensitive
    "test_visualiser"
  ];

  disabledTestPaths = [
    # Needs a running DBUS
    "test/widget/test_iwd.py"
    "test/widget/test_upower.py"
    # Marked as broken due to https://github.com/stravalib/stravalib/issues/379
    "test/widget/test_strava.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export GDK_PIXBUF_MODULE_FILE=${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
    sed -i 's#/usr/bin/sleep#sleep#' test/widget/test_snapcast.py
  '';

  pythonImportsCheck = [ "qtile_extras" ];

  passthru.tests.qtile-extras = nixosTests.qtile-extras;

  meta = {
    description = "Extra modules and widgets for the Qtile tiling window manager";
    homepage = "https://github.com/elParaguayo/qtile-extras";
    changelog = "https://github.com/elParaguayo/qtile-extras/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arjan-s ];
  };
}
