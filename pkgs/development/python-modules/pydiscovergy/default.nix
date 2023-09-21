{ lib
, authlib
, buildPythonPackage
, dataclasses-json
, fetchFromGitHub
, httpx
, marshmallow
, pytest-httpx
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
, respx
}:

buildPythonPackage rec {
  pname = "pydiscovergy";
  version = "2.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "pydiscovergy";
    rev = "refs/tags/${version}";
    hash = "sha256-iE80r9xXDI01gG0S9zhWsLSdVLQo2R4A5Ktnccsetzk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    authlib
    dataclasses-json
    httpx
    marshmallow
    pytz
  ];

  nativeCheckInputs = [
    pytest-httpx
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "pydiscovergy"
  ];

  meta = with lib; {
    description = "Async Python 3 library for interacting with the Discovergy API";
    homepage = "https://github.com/jpbede/pydiscovergy";
    changelog = "https://github.com/jpbede/pydiscovergy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
