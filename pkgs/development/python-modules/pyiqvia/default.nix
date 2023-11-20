{ lib
, buildPythonPackage
, aiohttp
, aresponses
, backoff
, certifi
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pyiqvia";
  version = "2023.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "pyiqvia";
    rev = "refs/tags/${version}";
    hash = "sha256-8eTa2h+1QOL0T13+lg2OzvaQv6CYYKkviQb4J5KPsvM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    certifi
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "pyiqvia"
  ];

  meta = with lib; {
    description = "Module for working with IQVIA data";
    longDescription = ''
      pyiqvia is an async-focused Python library for allergen, asthma, and
      disease data from the IQVIA family of websites (such as https://pollen.com,
      https://flustar.com and more).
    '';
    homepage = "https://github.com/bachya/pyiqvia";
    changelog = "https://github.com/bachya/pyiqvia/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
