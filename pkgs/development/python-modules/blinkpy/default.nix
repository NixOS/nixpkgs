{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, aiohttp
, pytestCheckHook
, python-dateutil
, python-slugify
, pythonOlder
, requests
, setuptools
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.22.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-J9eBZv/uizkZz53IX1ZfF7IeMOnBonyMD2c5DphW8BQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "wheel~=0.40.0"' ""
  '';

  nativeBuildInputs = [
    setuptools
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
    changelog = "https://github.com/fronzbot/blinkpy/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
