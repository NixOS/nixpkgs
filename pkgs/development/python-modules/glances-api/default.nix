{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    rev = "refs/tags/${version}";
    hash = "sha256-fcQgwOYGhpwxSXfa1PYFOe2UDTEu+2YGIQmuSa5J0g4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "glances_api"
  ];

  meta = with lib; {
    description = "Python API for interacting with Glances";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-glances-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
