{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  pyjwt,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pytz,
  titlecase,
  types-pytz,
}:

buildPythonPackage rec {
  pname = "aioridwell";
  version = "2024.01.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-B5k8uXDHq0U6fJVW8oy2sWUj5OIVGUfe9EtCjnIr3OE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    pyjwt
    pytz
    titlecase
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  disabledTests = [
    # AssertionError: assert datetime.date(...
    "test_get_next_pickup_event"
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [ "aioridwell" ];

  meta = with lib; {
    description = "Python library for interacting with Ridwell waste recycling";
    homepage = "https://github.com/bachya/aioridwell";
    changelog = "https://github.com/bachya/aioridwell/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
