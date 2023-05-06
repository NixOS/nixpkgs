{ lib
, aiohttp
, aioresponses
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, orjson
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "111";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "refs/tags/v${version}";
    hash = "sha256-QBun9VT42W9EMvNuLZoe6VnXKXAKEXstDKCU7LXEvNQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydeconz"
  ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    changelog = "https://github.com/Kane610/deconz/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
