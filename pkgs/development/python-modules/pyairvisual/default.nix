{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pygments,
  pysmb,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "2023.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "pyairvisual";
    tag = version;
    hash = "sha256-uN31LeHYmg4V6Ln3EQp765nOsN5v56TxjYSS/g6TUCY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    numpy
    pygments
    pysmb
  ];

  # this lets tests bind to localhost in sandbox mode on macOS
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [ "pyairvisual" ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
