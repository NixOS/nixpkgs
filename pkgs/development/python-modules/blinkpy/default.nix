{ lib
, aiofiles
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-dateutil
, python-slugify
, pythonOlder
, requests
, setuptools
, sortedcontainers
, wheel
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-r8kf5L6bvtivqd9dSi8om1wIi8IHmipKFckNMPT515I=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
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

  meta = with lib; {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    changelog = "https://github.com/fronzbot/blinkpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
