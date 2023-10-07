{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-dateutil
, python-slugify
, pythonAtLeast
, pythonOlder
, requests
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-0sEZlnS6CJj8nMyjtSFZRALRKdmY0Uu5N6sozPiDG6w=";
  };

  propagatedBuildInputs = [
    python-dateutil
    python-slugify
    requests
    sortedcontainers
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
    changelog = "https://github.com/fronzbot/blinkpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
