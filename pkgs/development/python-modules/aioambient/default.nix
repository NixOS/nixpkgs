{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-engineio
, python-socketio
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "aioambient";
  version = "2024.01.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioambient";
    rev = "refs/tags/${version}";
    hash = "sha256-eqZVY0L+2BWF7cCXW/VLQYYXNPtUF6tJHQmeZNW1W5o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    python-engineio
    python-socketio
    websockets
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  disabledTestPaths = [
    "examples/"
  ];

  pythonImportsCheck = [
    "aioambient"
  ];

  meta = with lib; {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    changelog = "https://github.com/bachya/aioambient/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
