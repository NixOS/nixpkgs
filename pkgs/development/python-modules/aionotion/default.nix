{ lib
, aiohttp
, aresponses
, buildPythonPackage
, certifi
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aionotion";
  version = "2024.01.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GugpZtpiX6BwypRaEcMIVrLSHxYcpVIRFr1Lk8B93P0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    pydantic
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [
    "examples"
  ];

  pythonImportsCheck = [
    "aionotion"
  ];

  meta = with lib; {
    description = "Python library for Notion Home Monitoring";
    homepage = "https://github.com/bachya/aionotion";
    changelog = "https://github.com/bachya/aionotion/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
