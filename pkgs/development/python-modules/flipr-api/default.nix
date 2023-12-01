{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, requests-mock
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, requests
}:

buildPythonPackage rec {
  pname = "flipr-api";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cnico";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-IAxB3i/HkwO5sjDh2aBCtijOcG0VIbatQjTWIh0inoM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flipr_api"
  ];

  meta = with lib; {
    description = "Python client for Flipr API";
    homepage = "https://github.com/cnico/flipr-api";
    changelog = "https://github.com/cnico/flipr-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
