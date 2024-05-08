{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, gql
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytibber";
  version = "0.29.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    rev = "refs/tags/${version}";
    hash = "sha256-fKeNQifSCxsqR2mhK2w5kG669byYNNLkfxAYTUtfWE0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    gql
  ] ++ gql.optional-dependencies.websockets;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/test.py"
  ];

  # Tests access network
  doCheck = false;

  pythonImportsCheck = [
    "tibber"
  ];

  meta = with lib; {
    description = "Python library to communicate with Tibber";
    homepage = "https://github.com/Danielhiversen/pyTibber";
    changelog = "https://github.com/Danielhiversen/pyTibber/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
