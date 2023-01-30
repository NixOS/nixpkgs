{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, python-slugify
, requests
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.19.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-depaXtbXo5F1JC3M24i6ynWhpm9x9O7UCjkoSzFaSZI=";
  };

  propagatedBuildInputs = [
    python-dateutil
    python-slugify
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blinkpy"
    "blinkpy.api"
    "blinkpy.auth"
    "blinkpy.blinkpy"
    "blinkpy.camera"
    "blinkpy.helpers.util"
    "blinkpy.sync_module"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    "test_download_video_exit"
    "test_parse_camera_not_in_list"
    "test_parse_downloaded_items"
  ];

  meta = with lib; {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
