{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, httpx
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iceportal";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-iceportal";
    rev = "refs/tags/${version}";
    hash = "sha256-edG4tF5nYaEOCcbunetYNL9moi9vA75IOkorDuLEx1c=";
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
    "iceportal"
  ];

  meta = with lib; {
    description = "Library for getting data from the ICE Portal";
    homepage = "https://github.com/home-assistant-ecosystem/python-iceportal";
    changelog = "https://github.com/home-assistant-ecosystem/python-iceportal/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
