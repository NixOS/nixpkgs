{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, xorgserver
, imagemagick
, gobject-introspection
, pulseaudio
, pytest-asyncio
, pytest-lazy-fixture
, qtile
, keyring
, requests
, librsvg
, gtk3
}:

buildPythonPackage rec {
  pname = "qtile-extras";
  version = "0.24.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "elParaguayo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DJmnJcqhfCfl39SF3Ypv0PGtI4r8heaVv9JmpiCBGJo=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    pytestCheckHook
    xorgserver
    imagemagick
    gobject-introspection
  ];
  checkInputs = [
    pytest-asyncio
    pytest-lazy-fixture
    qtile
    pulseaudio
    keyring
    requests
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
    # Needs github token
    "test_githubnotifications_reload_token"
    # AttributeError: 'NoneType' object has no attribute 'theta'
    "test_image_size_horizontal"
    "test_image_size_vertical"
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

  propagatedBuildInputs = [
    gtk3
  ];

  pythonImportsCheck = [ "qtile_extras" ];

  meta = with lib; {
    description = "Extra modules and widgets for the Qtile tiling window manager";
    homepage = "https://github.com/elParaguayo/qtile-extras";
    changelog = "https://github.com/elParaguayo/qtile-extras/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ arjan-s ];
  };
}
