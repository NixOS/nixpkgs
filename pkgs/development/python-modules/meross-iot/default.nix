{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pytestCheckHook
, pythonOlder
, requests
, retrying
}:

buildPythonPackage rec {
  pname = "meross-iot";
  version = "0.4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    rev = "refs/tags/${version}";
    sha256 = "sha256-6TWtqPYbHZKiAEHAGxZrPxvIiLdNhwOtqtgG+HtQGjI=";
  };

  propagatedBuildInputs = [
    aiohttp
    paho-mqtt
    requests
    retrying
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [
    "meross_iot"
  ];

  meta = with lib; {
    description = "Python library to interact with Meross devices";
    homepage = "https://github.com/albertogeniola/MerossIot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
