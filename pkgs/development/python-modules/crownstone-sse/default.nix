{ lib
, aiohttp
, buildPythonPackage
, certifi
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crownstone-sse";
  version = "2.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-sse";
    rev = version;
    hash = "sha256-z/z8MmydHkHubwuX02gGbOcOEZ+FHX4i82vAK5gAl+c=";
  };

  propagatedBuildInputs = [
    aiohttp
    certifi
  ];

  # Tests are only providing coverage
  doCheck = false;

  pythonImportsCheck = [
    "crownstone_sse"
  ];

  meta = with lib; {
    description = "Python module for listening to Crownstone SSE events";
    homepage = "https://github.com/crownstone/crownstone-lib-python-sse";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
