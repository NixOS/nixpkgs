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
<<<<<<< HEAD
  version = "113";
=======
  version = "111";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Vf3nYUopaGY5JK//rqqsz47VRHwql1cQcslYbkH3owQ=";
=======
    hash = "sha256-QBun9VT42W9EMvNuLZoe6VnXKXAKEXstDKCU7LXEvNQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
