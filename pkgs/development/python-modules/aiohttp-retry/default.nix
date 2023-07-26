{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-aiohttp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-retry";
  version = "2.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inyutin";
    repo = "aiohttp_retry";
    rev = "v${version}";
    hash = "sha256-Zr68gx8ZR9jKrogmqaFLvpBAIHE9ptHm0zZ/b49cCLw=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiohttp_retry"
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  meta = with lib; {
    description = "Retry client for aiohttp";
    homepage = "https://github.com/inyutin/aiohttp_retry";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
