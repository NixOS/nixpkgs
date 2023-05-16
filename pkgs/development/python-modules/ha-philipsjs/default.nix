{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, httpx
, pytest-aiohttp
, pytest-mock
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "ha-philipsjs";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VwgcN9DXzuWp6J3joswXEwRKJI499LNY7MAVBWBBEbM=";
=======
    hash = "sha256-5SneI1aZiUyLGYmtRXJYPBUtQR08fV+MWkjIQXt208s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
    httpx
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "haphilipsjs"
  ];

  meta = with lib; {
    description = "Python library to interact with Philips TVs with jointSPACE API";
    homepage = "https://github.com/danielperna84/ha-philipsjs";
    changelog = "https://github.com/danielperna84/ha-philipsjs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
