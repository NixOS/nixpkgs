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
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopurpleair";
  version = "2023.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2Ngo2pvzwcgQvpyW5Q97VQN/tGSVhVJwRj0DMaPn+O4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    certifi
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "aiopurpleair"
  ];

  meta = with lib; {
    description = "Python library for interacting with the PurpleAir API";
    homepage = "https://github.com/bachya/aiopurpleair";
    changelog = "https://github.com/bachya/aiopurpleair/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
