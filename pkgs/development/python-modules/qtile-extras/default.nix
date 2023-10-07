{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, xorgserver
, imagemagick
, pulseaudio
, pytest-asyncio
, pytest-lazy-fixture
, qtile
, keyring
, requests
, stravalib
}:

buildPythonPackage rec {
  pname = "qtile-extras";
  version = "0.23.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "elParaguayo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WI1z8vrbZiJw6fDHK27mKA+1FyZEQTMttIDNzSIX+PU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    pytestCheckHook
    xorgserver
    imagemagick
  ];
  checkInputs = [
    pytest-asyncio
    pytest-lazy-fixture
    qtile
    pulseaudio
    keyring
    requests
    stravalib
  ];
  disabledTests = [
    # AttributeError: 'ImgMask' object has no attribute '_default_size'. Did you mean: 'default_size'?
    # cairocffi.pixbuf.ImageLoadingError: Pixbuf error: Unrecognized image file format
    "test_draw"
    "test_icons"
    "1-x11-GithubNotifications-kwargs3"
    "1-x11-SnapCast-kwargs8"
    "1-x11-TVHWidget-kwargs10"
    "test_tvh_widget_not_recording"
    "test_tvh_widget_recording"
    "test_tvh_widget_popup"
    "test_snapcast_options"
    "test_snapcast_icon"
    "test_snapcast_icon_colour"
    "test_snapcast_http_error"
    "test_syncthing_not_syncing"
    "test_syncthing_is_syncing"
    "test_syncthing_http_error"
    "test_githubnotifications_colours"
    "test_githubnotifications_logging"
    "test_githubnotifications_icon"
    "test_githubnotifications_reload_token"
    "test_image_size_horizontal"
    "test_image_size_vertical"
    "test_image_size_mask"
    # ValueError: Namespace Gdk not available
    # AssertionError: Window never appeared...
    "test_statusnotifier_menu"
    # AttributeError: 'str' object has no attribute 'canonical'
    "test_strava_widget_display"
    "test_strava_widget_popup"
    # Needs a running DBUS
    "test_brightness_power_saving"
    "test_upower_all_batteries"
    "test_upower_named_battery"
    "test_upower_low_battery"
    "test_upower_critical_battery"
    "test_upower_charging"
    "test_upower_show_text"
    "test_global_menu"
    "test_mpris2_popup"
    # No network connection
    "test_wifiicon_internet_check"
    # AssertionErrors
    "test_widget_init_config"
    "test_decoration_output"
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "qtile_extras" ];

  meta = with lib; {
    description = "Extra modules and widgets for the Qtile tiling window manager";
    homepage = "https://github.com/elParaguayo/qtile-extras";
    changelog = "https://github.com/elParaguayo/qtile-extras/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ arjan-s ];
  };
}
