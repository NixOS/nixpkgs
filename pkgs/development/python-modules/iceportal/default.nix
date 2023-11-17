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
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-iceportal";
    rev = "refs/tags/${version}";
    hash = "sha256-s+jEpxKsa3eIV4a/Ltso51jqZC4jzsvPLTjDFMV9FIA=";
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
