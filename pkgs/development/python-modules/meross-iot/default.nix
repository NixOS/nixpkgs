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
  version = "0.4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "MerossIot";
    rev = version;
    sha256 = "sha256-NkLMQ1sgoZit2BQechgGq8XhBuzw2P7jKHsAjGq3l08=";
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
