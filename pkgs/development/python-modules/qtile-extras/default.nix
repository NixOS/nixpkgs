{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, xorgserver
, pulseaudio
, pytest-asyncio
, qtile-unwrapped
, keyring
, requests
, stravalib
}:

buildPythonPackage rec {
  pname = "qtile-extras";
  version = "0.22.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "elParaguayo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2dMpGLtwIp7+aoOgYav2SAjaKMiXHmmvsWTBEIMKEW4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    pytestCheckHook
    xorgserver
  ];
  checkInputs = [
    pytest-asyncio
    qtile-unwrapped
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
    # ValueError: Namespace Gdk not available
    # AssertionError: Window never appeared...
    "test_gloabl_menu"
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
